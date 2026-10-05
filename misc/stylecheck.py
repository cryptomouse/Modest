#!/usr/bin/env python3
"""Modest style checker — enforces docs/STYLE.md.

    misc/stylecheck.py                  check every tracked .modest file
    misc/stylecheck.py lib tests/x.modest   check these files / directories
    misc/stylecheck.py --fix ...        also fix what can be fixed safely
    misc/stylecheck.py -r name,blank    only these rules

Generated sources (anything under an `out/` directory) are skipped.

Rules:
    eof        the file ends with exactly two newlines          [fixable]
    trail      no trailing whitespace                           [fixable]
    indent     indentation is tabs only                         [fixable]
    comment    an inline comment is 2+ spaces away, no tabs     [fixable]
    blank      empty lines between top-level definitions        [fixable]
    defspace   `func name (` in a definition
    callspace  `name(` in a call
    brace      `{` on the header line
    else       `} else {` on one line
    name       camelCase / PascalCase identifiers, no `_`       [warning]

Warnings are reported but do not fail the check: many names in the C
bindings mirror C and keep its spelling.

A file opts out of a rule with a comment anywhere in it:
    // stylecheck: off brace, else
for tests that exercise the forms the guide does not allow.
"""

import argparse
import os
import re
import subprocess
import sys

FIXABLE_RULES = {'eof', 'trail', 'indent', 'comment', 'blank'}
WARN_RULES = {'name'}
ALL_RULES = ('eof', 'trail', 'indent', 'comment', 'blank',
             'defspace', 'callspace', 'brace', 'else', 'name')

# words that may be followed by ` (` without being a call
KEYWORDS = {
	'if', 'else', 'while', 'return', 'func', 'let', 'var', 'const', 'type',
	'and', 'or', 'not', 'is', 'as', 'include', 'import', 'break', 'again',
	'sizeof', 'alignof', 'offsetof', 'lengthof', 'public', 'private',
	'pragma', 'in',
}

# pragma directives are part of the language, not identifiers
PRAGMA_WORDS = {'do_not_include', 'c_include', 'c_no_print'}

INCLUDE_KINDS = ('include', 'import', 'pragma')


def split_line(line, in_block):
	"""Split a line into (code, comment, in_block).

	`code` has string and char literal contents and /* */ comments
	replaced by spaces, so it keeps the column positions of `line`;
	`comment` is the trailing `//` comment, if any.
	"""
	out = []
	i = 0
	quote = None
	while i < len(line):
		c = line[i]
		if in_block:
			if line.startswith('*/', i):
				in_block = False
				out.append('  ')
				i += 2
			else:
				out.append(' ')
				i += 1
			continue
		if quote:
			if c == '\\' and i + 1 < len(line):
				out.append('  ')
				i += 2
				continue
			out.append(c if c == quote else ' ')
			if c == quote:
				quote = None
			i += 1
			continue
		if c in '"\'':
			quote = c
			out.append(c)
		elif line.startswith('//', i):
			return ''.join(out), line[i:], in_block
		elif line.startswith('/*', i):
			in_block = True
			out.append('  ')
			i += 2
			continue
		else:
			out.append(c)
		i += 1
	return ''.join(out), '', in_block


class File:
	def __init__(self, path):
		self.path = path
		self.text = open(path, encoding='utf-8').read()
		self.lines = self.text.split('\n')
		if self.lines and self.lines[-1] == '':
			self.lines.pop()
		# per line: (code, comment, starts inside a block comment)
		self.parsed = []
		in_block = False
		for line in self.lines:
			was = in_block
			code, comment, in_block = split_line(line, in_block)
			self.parsed.append((code, comment, was))
		m = re.search(r'stylecheck:\s*off\s+([\w, ]+)', self.text)
		self.off = {r.strip() for r in m.group(1).split(',')} if m else set()


def top_level_items(f):
	"""Top-level definitions as dicts: kind, start (index of the first line,
	attached comments and annotations included), gap (empty lines between
	the previous item and the first line after it: a detached section
	comment sits inside the gap, not above it), body (func with a body)."""
	items = []
	blanks = 0
	attached = None
	gap = None
	depth = 0
	n = len(f.lines)
	i = 0
	while i < n:
		raw = f.lines[i]
		code, _, in_block = f.parsed[i]
		stripped = code.strip()
		if not raw.strip():
			if gap is not None and gap[1] == 0 and items:
				# comments right under the previous item (commented-out
				# code, mostly) stay with it; the gap starts after them
				gap = None
			blanks += 1
			attached = None
			i += 1
			continue
		if gap is None:
			gap = (i, blanks)
		bare_anno = stripped.startswith('@') and not re.search(
			r'\b(func|type|var|let|const)\b', stripped)
		# a pragma past the include section governs what follows it
		late_pragma = stripped.startswith('pragma') and any(
			it['kind'] not in INCLUDE_KINDS for it in items)
		if not stripped or bare_anno or late_pragma:
			# comment or annotation line: belongs to what follows
			if attached is None:
				attached = (i, blanks)
			blanks = 0
			i += 1
			continue
		start = attached[0] if attached else i
		attached = None
		words = [w for w in stripped.split()
		         if not w.startswith('@') and w not in ('public', 'private')]
		kind = words[0] if words else '?'
		# the item ends where its brackets balance
		j = i
		depth = 0
		while True:
			c = f.parsed[j][0]
			depth += sum(c.count(x) for x in '{([') - sum(c.count(x) for x in '})]')
			if depth <= 0 or j + 1 >= n:
				break
			j += 1
		body = False
		if kind == 'func':
			text = ' '.join(f.parsed[k][0] for k in range(i, j + 1))
			body = bool(re.search(r'\)\s*(->[^{]*?)?\{', text) or
			            re.search(r'\bfunc\s+\w+\s+[A-Z]\w*\s*\{', text))
			if not body and j + 1 < n and f.parsed[j + 1][0].strip() == '{':
				body = True  # next-line brace
				while j + 1 < n:
					j += 1
					depth += sum(f.parsed[j][0].count(x) for x in '{([')
					depth -= sum(f.parsed[j][0].count(x) for x in '})]')
					if depth <= 0:
						break
		items.append({'kind': kind, 'start': start, 'body': body,
		              'gap_at': gap[0], 'gap': gap[1]})
		blanks = 0
		gap = None
		i = j + 1
	return items


def blank_ranges(items):
	"""For each item after the first: (index, lo, hi, why)."""
	out = []
	seen_func = False
	for k in range(1, len(items)):
		prev, cur = items[k - 1], items[k]
		pk, ck = prev['kind'], cur['kind']
		if pk in INCLUDE_KINDS and ck not in INCLUDE_KINDS:
			rng = (2, 2, 'after the include section')
		elif pk in INCLUDE_KINDS:
			rng = (0, 1, 'inside the include section')
		elif cur['body'] and not seen_func:
			rng = (2, 2, 'before the function section')
		elif cur['body']:
			rng = (1, 2, 'before a function definition')
		elif prev['body']:
			rng = (1, 2, 'after a function definition')
		elif pk == 'func' or ck == 'func':
			rng = (0, 2, 'between declarations')
		else:
			rng = (0, 1, 'between top-level blocks')
		if cur['body']:
			seen_func = True
		out.append((k,) + rng)
	return out


def check(f, rules, fix):
	errs = []
	active = [r for r in rules if r not in f.off]

	def err(n, rule, msg):
		if rule in active:
			errs.append((n, rule, msg))

	lines = list(f.lines)
	for i, raw in enumerate(lines):
		n = i + 1
		code, comment, in_block = f.parsed[i]

		if raw != raw.rstrip():
			err(n, 'trail', 'trailing whitespace')
			if fix and 'trail' in active:
				lines[i] = raw = raw.rstrip()

		if not in_block:
			lead = raw[:len(raw) - len(raw.lstrip(' \t'))]
			if ' ' in lead and raw.strip():
				err(n, 'indent', 'indentation with spaces')
				if fix and 'indent' in active:
					level = 0
					spaces = 0
					for c in lead:
						if c == '\t':
							level += 1
							spaces = 0
						else:
							spaces += 1
							if spaces == 4:
								level += 1
								spaces = 0
					lines[i] = raw = '\t' * level + raw.lstrip(' \t')
					code, comment, _ = split_line(raw, False)

		if comment and code.strip():
			# two spaces or more (aligning a column), never tabs
			gap = code[len(code.rstrip()):]
			if len(gap) < 2 or '\t' in gap:
				err(n, 'comment', 'inline comment must be separated by at least two spaces')
				if fix and 'comment' in active:
					# keep the column the comment was at (tab width 4)
					cut = len(code.rstrip())
					width = (len(raw[:len(code)].expandtabs(4)) -
					         len(raw[:cut].expandtabs(4)))
					lines[i] = raw = raw[:cut] + ' ' * max(2, width) + raw[len(code):]

		m = re.search(r'\bfunc\s+(\w+)\(', code)
		if m:
			err(n, 'defspace', f'`func {m.group(1)} (`: a space after the name in a definition')
		rest = re.sub(r'\bfunc\s+\w+\s*', '', code)
		for m in re.finditer(r'(?<![\w.@])([a-z_]\w*)[ \t]+\(', rest):
			# a type name before `(` is value construction, not a call
			if m.group(1) not in KEYWORDS:
				err(n, 'callspace', f'`{m.group(1)}(`: no space before `(` in a call')

		if code.strip() == '{' and i > 0 and re.match(
				r'\s*(\}\s*)?(if|else|while|(.*\W)?func)\b', f.parsed[i - 1][0]):
			err(n, 'brace', '`{` belongs on the header line')
		if re.match(r'\s*else\b', code):
			err(n, 'else', '`else` belongs on the line of `}`: `} else {`')

		for m in re.finditer(r'(?<![\w@])([A-Za-z]\w*_\w*)', code):
			if m.group(1) not in PRAGMA_WORDS:
				err(n, 'name', f'`{m.group(1)}`: names are camelCase / PascalCase')
		for m in re.finditer(r'(?<![\w@])(_\w+)', code):
			err(n, 'name', f'`{m.group(1)}`: names are camelCase / PascalCase')

	if 'blank' in active:
		g = File.__new__(File)
		g.path, g.lines, g.off = f.path, lines, f.off
		g.parsed = []
		in_block = False
		for line in lines:
			was = in_block
			code, comment, in_block = split_line(line, in_block)
			g.parsed.append((code, comment, was))
		items = top_level_items(g)
		edits = []
		for k, lo, hi, why in blank_ranges(items):
			b = items[k]['gap']
			if not lo <= b <= hi:
				want = lo if b < lo else hi
				span = f'{lo}' if lo == hi else f'{lo}-{hi}'
				err(items[k]['start'] + 1, 'blank',
				    f'{b} empty line(s) {why}, need {span}')
				edits.append((items[k]['gap_at'], b, want))
		if fix:
			for start, have, want in reversed(edits):
				lines[start - have:start] = [''] * want

	text = '\n'.join(lines) + '\n'
	tail = len(f.text) - len(f.text.rstrip('\n'))
	if tail != 2:
		err(len(f.lines), 'eof', f'the file ends with {tail} newline(s), need 2 (`}}\\n\\n`)')
	if 'eof' in active:
		text = text.rstrip('\n') + '\n\n'
	else:
		text = text.rstrip('\n') + '\n' * tail

	if fix and text != f.text:
		with open(f.path, 'w', encoding='utf-8') as out:
			out.write(text)
	return errs


def discover(paths, root):
	if not paths:
		res = subprocess.run(['git', 'ls-files', '*.modest'], cwd=root,
		                     capture_output=True, text=True, check=True)
		files = [os.path.join(root, p) for p in res.stdout.split()]
	else:
		files = []
		for p in paths:
			if os.path.isdir(p):
				for d, dirs, names in os.walk(p):
					dirs[:] = sorted(x for x in dirs if x != 'out' and not x.startswith('.'))
					files += [os.path.join(d, x) for x in sorted(names) if x.endswith('.modest')]
			else:
				files.append(p)
	return [p for p in files if 'out' not in p.split(os.sep)[:-1]]


def main():
	ap = argparse.ArgumentParser(description='Check .modest sources against docs/STYLE.md')
	ap.add_argument('paths', nargs='*', help='files or directories (default: all tracked)')
	ap.add_argument('--fix', action='store_true', help='fix trail/indent/comment/blank/eof in place')
	ap.add_argument('-r', '--rules', help='comma-separated rules to check (default: all)')
	args = ap.parse_args()

	rules = ALL_RULES
	if args.rules:
		rules = tuple(r.strip() for r in args.rules.split(','))
		bad = [r for r in rules if r not in ALL_RULES]
		if bad:
			ap.error(f'unknown rule(s): {", ".join(bad)}')

	root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
	errors = warnings = fixed = 0
	for path in discover(args.paths, root):
		shown = os.path.relpath(path)
		for n, rule, msg in check(File(path), rules, args.fix):
			if rule in WARN_RULES:
				print(f'{shown}:{n}: warning: [{rule}] {msg}')
				warnings += 1
			elif args.fix and rule in FIXABLE_RULES:
				print(f'{shown}:{n}: fixed: [{rule}] {msg}')
				fixed += 1
			else:
				print(f'{shown}:{n}: [{rule}] {msg}')
				errors += 1
	if errors or warnings or fixed:
		print(f'\n{errors} error(s), {warnings} warning(s), {fixed} fixed', file=sys.stderr)
	return 1 if errors else 0


if __name__ == '__main__':
	sys.exit(main())
