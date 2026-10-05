# Modest Style Guide

The official way to write Modest source.  Every `.modest` file in this
repository follows it — library, examples, tests and test fixtures alike.

The compiler accepts more than this guide allows: these are rules of
writing, not of the language.  Where a rule *is* enforced by the compiler,
it says so.


## File layout

- Between semantically distinct top-level blocks (type definitions,
  constants, variables) — **one empty line**.
- After the `include`/`import` section — **two empty lines**, separating
  it from whatever definitions follow.
- Between function definitions — **one or two empty lines**.
- Before the function-definitions section (after the includes, types,
  constants and variables) — **two empty lines**, so the functions are
  clearly set apart from the preamble.
- A function definition **with a body** is separated from the previous
  definition, of any kind, by **at least one empty line** — never written
  right under it.  Bodiless declarations (e.g. `@extern` prototypes) may
  follow each other line by line.
- A comment or annotation that belongs to a definition sits right above
  it, with no empty line between; the empty lines go above the comment.
- At the end of a file — **two empty lines**, whatever the last line is:
  the last line is followed by exactly one more newline (`}\n\n`), which an
  editor shows as two empty lines.

```modest
include "libc/ctypes64"
include "libc/stdio"


type Point = {x: Float64, y: Float64}

const maxSize = 100


// set p to the origin
func init (p: *Point) -> Unit {
	p.x = 0.0
	p.y = 0.0
}


func distance (a: Point, b: Point) -> Float64 {
	let dx = a.x - b.x  // x delta
	let dy = a.y - b.y  // y delta
	return sqrt(dx*dx + dy*dy)
}
```


## Indentation

- Indent with **tabs**, one tab per nesting level.


## Names

- *PascalCase* for types, *camelCase* for everything else: variables,
  constants, functions, parameters, fields, modules.
- Identifiers are ASCII only; Unicode belongs in comments and string
  literals.

The case of the first letter is enforced by the compiler — it is what
tells a type identifier from a value identifier
([identifiers](./lang/identifier.md)).  The rest of the casing is style.


## Functions

- In a **definition**, the name is separated from the parameter list by a
  space; in a **call** it is not:

```modest
func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func main () -> Int {
	return add(1, 2)
}
```


## Braces

- The opening `{` goes on the same line as its header (`func`, `if`,
  `else`, `while`).  The compiler also accepts it on the next line
  ([block](./lang/stmt/block.md)), but library code does not use that.
  (Planned: Allman as an alternative, one style per file — see
  [TODO](./todo/TODO.md#brace-style-kr-or-allman-one-per-file).)
- `else` follows the closing `}` on the same line: `} else {`.  The
  next-line `else` is experimental and may be dropped.


## Comments

- An inline comment (to the right of a line of code) is separated from
  the code by **at least two spaces**: `return 0  // done`.  More spaces
  are fine when they align the comments of neighbouring lines into a
  column; the gap is made of spaces only, never tabs.

```modest
const eperm: Errno = 1   // Operation not permitted
const enoent: Errno = 2  // No such file or directory
const esrch: Errno = 3   // No such process
```


## See also

- [Cheat sheet](./CHEATSHEET.md) — the language itself
- [Tests](../tests/README.md) — tests follow this guide too
- `misc/stylecheck.py` — checks sources against this guide; `--fix`
  repairs the layout rules in place
