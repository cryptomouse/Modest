# Function Definition

Binds an [identifier](../identifier.md) to a function with the given
[function type](../type/func.md) and body.

## Form

```
func <#identifier#> <#FuncType#> {
	<#statements#>
}
```

The return type is mandatory; use `Unit` for functions returning nothing.

A non-`Unit` function must end with `return`; otherwise the compiler warns
(`expected return operator at end`) and returns a default value.

```modest
func hello () -> Unit {
	printf("hello\n")
}

// the opening `{` may also stand alone on the next line
func sum (a: Int32, b: Int32) -> Int32
{
	return a + b
}
```

> Only one newline is allowed before `{` — after a blank line it no longer
> belongs to the signature.

`<#FuncType#>` may also be the name of a function type — parameter names
then come from the type:

```modest
type FailHandler = (code: Int32) -> Unit

func onDiskFail FailHandler {
	printf("disk failed with code %d\n", code)
}
```

## Parameters

Parameters are [fields](../fields.md): `name: Type`. Additionally:

- **Default values**: `name: Type = value` — the argument may be omitted.
- **Named arguments**: any call may pass arguments by name:
  `f(b = 2, a = 1)` (see [call](../value/call.md)).
- **Variadic**: a trailing `...` accepts C-style varargs
  (see [va_arg](../va_arg.md)).
- **Unused parameters** give a warning (`parameter 'x' is not used`);
  mark an intentionally unused one with `@unused`: `x: @unused Int32`.

```modest
func greet (name: *Str8 = "World") -> Unit { ... }
```

## Nested functions

A function may be defined inside another one. Its name is local to the
enclosing body, and it does **not** capture variables (no closures).
Local `type` definitions are allowed too.

```modest
func main () -> Int {
	func twice (x: Int32) -> Int32 {
		return x * 2
	}
	return twice(21) - 42
}
```

## Declarations

A definition without a body is a *declaration* of a function defined
outside the module; mark it `@extern` (see [annotations](../annotation.md)).

```modest
@extern
public func printf (format: *Str8, ...) -> Int
```

> Notes:
>
> - It is not a forward declaration: a function may be called before its
>   definition, and declaring it again in the same module is a redefinition.
> - `@alias`, which renames a function in the output, needs a body.

## Notes

- The program entry point is `func main () -> Int`.
- `&name` takes the function's address as a
  [pointer to function](../type/func.md).
- Inlining: `@inline` / `@inlinehint` / `@noinline`
  (see [annotations](../annotation.md)).
- A function whose body is a single `return`, with no pointers in its
  parameters or result, is pure: its calls with compile-time arguments are
  folded (see [compile-time calls](../value/call.md#compile-time-calls)).
  `@runtime` turns that off.
