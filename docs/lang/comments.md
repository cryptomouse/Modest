# Comments

Comments are for the reader — they do not affect compilation.

## Syntax

```
// <#any text — to end of line#>
/* <#any text#> */
```

## Semantics

- `//` extends to the end of the line; the newline itself still
  terminates the statement.
- `/* ... */` may span several lines. Block comments do **not** nest —
  the first `*/` closes the comment.
- Comments are not carried into the output. Exception: the `modest`
  pretty-printer backend preserves them — at the top level and inside
  bodies, with the blank lines around them.
  (Planned: full pass-through for the `c11` backend —
  see [TODO](../todo/TODO.md).)
- Unicode is allowed in comments (and string literals) — but not in
  [identifiers](./identifier.md).

## Examples

```modest
// about main
func main () -> Int {
	/* block
	   comment */
	// line comment
	return 0
}
```

## See also

- [Style guide](../STYLE.md)
