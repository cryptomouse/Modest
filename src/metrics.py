# src/metrics.py
#
# Метрики исходника (--metrics).
#
# Считаются по HLIR, уже после семантики: всё, что видно только компилятору —
# виды определений, операторы, способы конструирования значений, размеры
# статических данных и кадров локальных переменных.  Печатается в YAML
# в stdout, по одному документу на каждый входной файл.

import os
import json

from hlir import *
from common import get_setting


# операции, дающие ветвление (для цикломатической сложности)
DECISION_OPS = (HLIR_VALUE_OP_LOGIC_AND, HLIR_VALUE_OP_LOGIC_OR)


def bump(d, k, n=1):
	d[k] = d.get(k, 0) + n


# Раскладывает строки исходника на пустые / только с комментарием / с кодом.
# Считается по тексту, а не по AST: парсер оставляет от комментариев только
# те, что стоят непосредственно перед оператором, - остальные до HLIR не
# доходят.  Правила те же, что у лексера (lexer.doLineComment /
# doBlockComment / doString): блочные комментарии не вложенные, строковый
# литерал берётся в '"' или "'" и знает про экранирование.
def scan_lines(text):
	lines = text.splitlines()
	n = len(lines)
	has_code = [False] * n
	has_comment = [False] * n

	line = 0
	i = 0
	size = len(text)
	block = False   # внутри /* */
	quote = None    # внутри строкового литерала

	while i < size:
		c = text[i]

		if c == '\n':
			line += 1
			i += 1
			continue

		if line >= n:
			break

		if block:
			has_comment[line] = True
			if c == '*' and text[i+1:i+2] == '/':
				block = False
				i += 2
				continue
			i += 1
			continue

		if quote != None:
			has_code[line] = True
			if c == '\\':
				i += 2
				continue
			if c == quote:
				quote = None
			i += 1
			continue

		if c == '/' and text[i+1:i+2] == '/':
			has_comment[line] = True
			while i < size and text[i] != '\n':
				i += 1
			continue

		if c == '/' and text[i+1:i+2] == '*':
			has_comment[line] = True
			block = True
			i += 2
			continue

		if c == '"' or c == "'":
			has_code[line] = True
			quote = c
			i += 1
			continue

		if not c.isspace():
			has_code[line] = True
		i += 1

	blank = 0
	comment = 0
	code = 0
	for k in range(n):
		if has_code[k]:
			code += 1
		elif has_comment[k]:
			comment += 1
		else:
			blank += 1

	return {'total': n, 'blank': blank, 'comment': comment, 'code': code}


# номер строки, на которой начинается сущность (или 0, если позиции нет)
def line_of(x):
	ti = getattr(x, 'ti', None)
	if ti == None:
		return 0
	tok = ti.getLeftTokenInfo() if isinstance(ti, TextInfo) else ti
	if tok == None:
		return 0
	return tok.line


def is_public(x):
	return getattr(x, 'access_level', None) == HLIR_ACCESS_LEVEL_PUBLIC


def size_of(t):
	if t == None:
		return 0
	try:
		return int(t.get_size())
	except (TypeError, ValueError):
		return 0


def stmt_kind(s):
	if isinstance(s, StmtCommentLine): return 'comment_line'
	if isinstance(s, StmtCommentBlock): return 'comment_block'
	if isinstance(s, StmtComment): return 'comment'
	if isinstance(s, StmtImport): return 'include' if s.include else 'import'
	if isinstance(s, StmtDefType): return 'type'
	if isinstance(s, StmtDefVar): return 'var'
	if isinstance(s, StmtDefConst): return 'const'
	if isinstance(s, StmtDefFunc): return 'func'
	if isinstance(s, StmtBlock): return 'block'
	if isinstance(s, StmtValueExpression): return 'expression'
	if isinstance(s, StmtAssign): return 'assign'
	if isinstance(s, StmtIncrement): return 'increment'
	if isinstance(s, StmtDecrement): return 'decrement'
	if isinstance(s, StmtIf): return 'if'
	if isinstance(s, StmtWhile): return 'while'
	if isinstance(s, StmtAgain): return 'again'
	if isinstance(s, StmtBreak): return 'break'
	if isinstance(s, StmtReturn): return 'return'
	if isinstance(s, StmtAsm): return 'asm'
	if isinstance(s, StmtDirectiveCInclude): return 'c_include'
	if isinstance(s, StmtDirectiveInsert): return 'insert'
	if isinstance(s, StmtDirective): return 'directive'
	if isinstance(s, StmtBad): return 'bad'
	return 'other'


# операторы, которые не исполняются: в счёт тела функции не идут
NON_EXEC_STMTS = ('block', 'comment', 'comment_line', 'comment_block')


def value_kind(v):
	if isinstance(v, ValueCall): return 'call'
	if isinstance(v, ValueCons): return 'cons'
	if isinstance(v, ValueBin): return 'binary'
	if isinstance(v, (ValueShl, ValueShr)): return 'shift'
	if isinstance(v, (ValueNot, ValueNeg, ValuePos)): return 'unary'
	if isinstance(v, ValueRef): return 'ref'
	if isinstance(v, ValueDeref): return 'deref'
	if isinstance(v, ValueNew): return 'new'
	if isinstance(v, ValueIndex): return 'index'
	if isinstance(v, ValueSlice): return 'slice'
	if isinstance(v, ValueAccessRecord): return 'field_access'
	if isinstance(v, ValueAccessModule): return 'module_access'
	if isinstance(v, ValueSubexpr): return 'subexpr'
	if isinstance(v, (ValueSizeofType, ValueSizeofValue)): return 'sizeof'
	if isinstance(v, (ValueAlignofType, ValueAlignofValue)): return 'alignof'
	if isinstance(v, (ValueLengthofType, ValueLengthofValue)): return 'lengthof'
	if isinstance(v, ValueOffsetof): return 'offsetof'
	if isinstance(v, (ValueVaStart, ValueVaArg, ValueVaEnd, ValueVaCopy)): return 'va_arg'
	if isinstance(v, ValueArray): return 'array_literal'
	if isinstance(v, ValueRecord): return 'record_literal'
	if isinstance(v, ValueLiteral): return 'literal'
	if isinstance(v, ValueVar): return 'var_ref'
	if isinstance(v, ValueConst): return 'const_ref'
	if isinstance(v, ValueFunc): return 'func_ref'
	if isinstance(v, ValueUndefined): return 'undefined'
	if isinstance(v, ValueBad): return 'bad'
	return 'other'


def type_kind(t):
	if t == None: return 'unknown'
	if t.is_record(): return 'record'
	if t.is_variant(): return 'variant'
	if t.is_array(): return 'array'
	if t.is_pointer(): return 'pointer'
	if t.is_func(): return 'func'
	return 'alias'


class FuncMetrics:
	def __init__(self, definition):
		func = definition.value
		ft = func.type

		self.name = func.id.str
		self.line = line_of(definition)
		self.params = len(ft.params) if hasattr(ft, 'params') else 0
		self.variadic = bool(getattr(ft, 'extra_args', False))
		self.public = is_public(definition)
		self.prototype = definition.stmt == None
		self.pure = bool(getattr(func, 'is_pure', False))

		self.stmts = 0
		self.calls = 0
		self.locals = 0
		self.locals_bytes = 0
		self.nesting = 0
		self.cyclomatic = 1


class Metrics:
	def __init__(self, module):
		self.module = module

		self.stmts = {}   # вид оператора -> количество
		self.values = {}  # вид значения -> количество
		self.types = {}   # вид типа -> количество
		self.cons = {}    # способ конструирования -> количество

		self.nstmts = 0
		self.nvalues = 0

		self.imports = {'total': 0, 'modules': 0, 'includes': 0, 'unused': 0}
		self.ntypes = {'total': 0, 'public': 0}
		self.nvars = {'total': 0, 'public': 0, 'bytes': 0}
		self.nconsts = {'total': 0, 'public': 0, 'bytes': 0}

		self.funcs = []
		self.cur = None  # функция, тело которой обходим сейчас


	def collect(self):
		for x in self.module.defs:
			self.top_level(x)
		return self


	def top_level(self, x):
		if isinstance(x, StmtImport):
			self.imports['total'] += 1
			if x.include:
				# у include usecnt не ведётся: такой StmtImport не попадает
				# в module.imports, считать его неиспользуемым нельзя
				self.imports['includes'] += 1
			else:
				self.imports['modules'] += 1
				if x.usecnt == 0:
					self.imports['unused'] += 1
			self.count_stmt(x)
			return

		if isinstance(x, StmtDefType):
			self.ntypes['total'] += 1
			if is_public(x):
				self.ntypes['public'] += 1
			bump(self.types, type_kind(x.type))
			self.count_stmt(x)
			return

		if isinstance(x, StmtDefVar):
			self.nvars['total'] += 1
			if is_public(x):
				self.nvars['public'] += 1
			self.nvars['bytes'] += size_of(x.value.type)
			self.count_stmt(x)
			self.walk_value(x.init_value)
			return

		if isinstance(x, StmtDefConst):
			self.nconsts['total'] += 1
			if is_public(x):
				self.nconsts['public'] += 1
			self.nconsts['bytes'] += size_of(x.value.type)
			self.count_stmt(x)
			self.walk_value(x.init_value)
			return

		if isinstance(x, StmtDefFunc):
			self.count_stmt(x)
			fs = FuncMetrics(x)
			self.funcs.append(fs)
			self.cur = fs
			self.walk_stmt(x.stmt, 1)
			self.cur = None
			return

		self.count_stmt(x)


	def count_stmt(self, s):
		kind = stmt_kind(s)
		bump(self.stmts, kind)
		self.nstmts += 1

		if self.cur != None and kind not in NON_EXEC_STMTS:
			self.cur.stmts += 1


	def walk_stmt(self, s, depth):
		if not isinstance(s, Stmt):
			return

		self.count_stmt(s)

		cur = self.cur

		if isinstance(s, StmtBlock):
			if cur != None and depth > cur.nesting:
				cur.nesting = depth
			for x in s.stmts:
				self.walk_stmt(x, depth + 1)
			return

		if isinstance(s, StmtIf):
			if cur != None:
				cur.cyclomatic += 1
			self.walk_value(s.cond)
			self.walk_stmt(s.then, depth)
			self.walk_stmt(s.els, depth)
			return

		if isinstance(s, StmtWhile):
			if cur != None:
				cur.cyclomatic += 1
			self.walk_value(s.cond)
			self.walk_stmt(s.stmt, depth)
			return

		if isinstance(s, StmtAssign):
			self.walk_value(s.left)
			self.walk_value(s.right)
			return

		if isinstance(s, (StmtDefVar, StmtDefConst)):
			if cur != None:
				cur.locals += 1
				cur.locals_bytes += size_of(s.value.type)
			self.walk_value(s.init_value)
			return

		if isinstance(s, StmtDefType):
			bump(self.types, type_kind(s.type))
			return

		if isinstance(s, StmtAsm):
			for io in list(s.outputs) + list(s.inputs):
				self.walk_value(io.get('value') if isinstance(io, dict) else getattr(io, 'value', None))
			return

		# StmtValueExpression / StmtReturn / StmtIncrement / StmtDecrement
		self.walk_value(getattr(s, 'value', None))


	def walk_value(self, v):
		if not isinstance(v, Value):
			return

		bump(self.values, value_kind(v))
		self.nvalues += 1
		cur = self.cur

		if isinstance(v, ValueCall):
			if cur != None:
				cur.calls += 1
			self.walk_value(v.func)
			for a in v.args:
				self.walk_value(a.value if isinstance(a, Initializer) else a)
			return

		if isinstance(v, ValueCons):
			bump(self.cons, v.method)
			self.walk_value(v.value)
			return

		if isinstance(v, ValueBin):
			if v.op in DECISION_OPS and cur != None:
				cur.cyclomatic += 1
			self.walk_value(v.left)
			self.walk_value(v.right)
			return

		if isinstance(v, (ValueShl, ValueShr)):
			self.walk_value(v.left)
			self.walk_value(v.right)
			return

		if isinstance(v, ValueIndex):
			self.walk_value(v.left)
			self.walk_value(v.index)
			return

		if isinstance(v, ValueSlice):
			self.walk_value(v.left)
			self.walk_value(v.index_from)
			self.walk_value(v.index_to)
			return

		if isinstance(v, ValueAccessRecord):
			self.walk_value(v.left)
			return

		# дальше — чужой модуль: его статистика считается на своём файле
		if isinstance(v, ValueAccessModule):
			return

		if isinstance(v, (ValueArray, ValueRecord)):
			items = v.asset
			if isinstance(items, list):
				for it in items:
					self.walk_value(it.value if isinstance(it, Initializer) else it)
			return

		# ссылка на определение: его тело считается там, где оно определено
		if isinstance(v, (ValueVar, ValueConst, ValueFunc)):
			return

		# ValueNot/Neg/Pos/Ref/Deref/Subexpr/New/sizeof/alignof/lengthof
		self.walk_value(getattr(v, 'value', None))
		self.walk_value(getattr(v, 'ofvalue', None))


	# --- сведение результата в структуру для печати ---------------------

	def source_lines(self):
		path = self.module.source_abspath
		if path == None:
			path = self.module.sourcename
		if path == None or not os.path.isfile(path):
			return None

		try:
			with open(path, encoding=get_setting('encoding')) as f:
				text = f.read()
		except (OSError, UnicodeDecodeError):
			return None

		return scan_lines(text)


	def report(self):
		funcs = self.funcs
		bodies = [f for f in funcs if not f.prototype]

		heaviest = max(bodies, key=lambda f: f.locals_bytes, default=None)
		hardest = max(bodies, key=lambda f: f.cyclomatic, default=None)
		deepest = max(bodies, key=lambda f: f.nesting, default=None)

		r = {}
		r['module'] = self.module.id
		r['source'] = self.module.sourcename

		lines = self.source_lines()
		if lines != None:
			r['lines'] = lines

		r['imports'] = dict(self.imports)

		r['definitions'] = {
			'types': dict(self.ntypes, **{'by_kind': dict(self.types)}),
			'functions': {
				'total': len(funcs),
				'public': sum(1 for f in funcs if f.public),
				'prototypes': sum(1 for f in funcs if f.prototype),
				'pure': sum(1 for f in funcs if f.pure),
				'variadic': sum(1 for f in funcs if f.variadic),
				'params_max': max((f.params for f in funcs), default=0),
			},
			'variables': dict(self.nvars),
			'constants': dict(self.nconsts),
		}

		r['statements'] = dict({'total': self.nstmts}, **dict(self.stmts))
		r['values'] = dict({'total': self.nvalues}, **dict(self.values))
		if self.cons != {}:
			r['values']['cons_by_method'] = dict(self.cons)

		r['memory'] = {
			'variables_bytes': self.nvars['bytes'],
			'constants_bytes': self.nconsts['bytes'],
			'frame_max_bytes': heaviest.locals_bytes if heaviest != None else 0,
			'frame_max_func': heaviest.name if heaviest != None else None,
		}

		r['complexity'] = {
			'nesting_max': deepest.nesting if deepest != None else 0,
			'nesting_max_func': deepest.name if deepest != None else None,
			'cyclomatic_max': hardest.cyclomatic if hardest != None else 0,
			'cyclomatic_max_func': hardest.name if hardest != None else None,
		}

		r['functions'] = [{
			'name': f.name,
			'line': f.line,
			'params': f.params,
			'statements': f.stmts,
			'calls': f.calls,
			'locals': f.locals,
			'locals_bytes': f.locals_bytes,
			'nesting': f.nesting,
			'cyclomatic': f.cyclomatic,
		} for f in bodies]

		return r


######################################################################
#                          YAML OUTPUT                               #
######################################################################

YAML_SPECIAL_HEAD = '-?:,[]{}#&*!|>\'"%@`'
YAML_RESERVED = ('true', 'false', 'null', 'yes', 'no', 'on', 'off', '~')


def yaml_scalar(v):
	if v == None:
		return 'null'
	if isinstance(v, bool):
		return 'true' if v else 'false'
	if isinstance(v, int):
		return str(v)

	s = str(v)
	quote = (s == ''
		or s[0] in YAML_SPECIAL_HEAD
		or s != s.strip()
		or ': ' in s
		or ' #' in s
		or s.lower() in YAML_RESERVED)
	if quote:
		return '"%s"' % s.replace('\\', '\\\\').replace('"', '\\"')
	return s


def yaml_lines(node, indent=0):
	pad = '  ' * indent
	ss = []

	if isinstance(node, dict):
		for k, v in node.items():
			if isinstance(v, dict):
				if v == {}:
					ss.append("%s%s: {}" % (pad, k))
					continue
				ss.append("%s%s:" % (pad, k))
				ss.extend(yaml_lines(v, indent + 1))
			elif isinstance(v, list):
				if v == []:
					ss.append("%s%s: []" % (pad, k))
					continue
				ss.append("%s%s:" % (pad, k))
				for item in v:
					sub = yaml_lines(item, indent + 2)
					ss.append("%s  - %s" % (pad, sub[0].lstrip()))
					ss.extend(sub[1:])
			else:
				ss.append("%s%s: %s" % (pad, k, yaml_scalar(v)))
		return ss

	if isinstance(node, list):
		for item in node:
			sub = yaml_lines(item, indent + 1)
			ss.append("%s- %s" % (pad, sub[0].lstrip()))
			ss.extend(sub[1:])
		return ss

	ss.append("%s%s" % (pad, yaml_scalar(node)))
	return ss


# главная точка входа: собрать метрики модуля и напечатать их в stdout
def run(module, fmt='yaml'):
	report = Metrics(module).collect().report()

	if fmt == 'json':
		# по документу на файл, как и у YAML: jq читает поток склеенных
		# объектов как есть, 'jq -s .' соберёт их в массив
		print(json.dumps(report, indent=2, ensure_ascii=False))
		return

	print('---')
	for line in yaml_lines(report):
		print(line)
