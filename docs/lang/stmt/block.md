# Block

A *block* is a brace-delimited sequence of statements forming the body of
a [function](../def/func.md), [`if`](./if.md) branch or
[`while`](./while.md) loop.

```
{ <#statements#> }
```

## Semantics

- Statements execute in order, top to bottom.
- Names defined in a block (`var`, `let`, local `type`, nested `func`) are
  visible from their definition to the end of that block.
- A bare `{ ... }` is **not** a standalone statement — blocks exist only
  as bodies of the constructs above.
- Brace placement: the opening `{` may follow its header on the same line
  (*same-line* style) or sit alone on the next line (*next-line* style) —
  a single newline between them is allowed, a blank line is not. This
  holds for every block: `func`, `if`, `else`, `while`.
- **Experimental:** next-line `else` — it may start the line after the `}`
  that closes the previous branch. This may be dropped; don't rely on it
  in library code. `ALLOW_BRACE_ON_NEXT_LINE` in `src/parser.py` turns
  both next-line forms off.
- The `modest` backend (pretty-printer) emits same-line by default; the
  settings `backend.modest.brace_style` and `backend.modest.else_style`
  (`"same-line"` / `"next-line"`, in `cfg/*.toml` or
  `-mbackend.modest.brace_style=next-line`) pick the layout of `{` and of
  `else` independently.

```modest
while i < 10
{
	++i
}

if a > b
{
	...
}
else            // experimental
{
	...
}
```

## Example

```modest
func main: () -> Int {
	var x: Int32 = 1          // visible to end of function
	if x > 0 {
		let y = x * 2         // visible to end of this branch
		printf("%d\n", y)
	}
	return 0
}
```
