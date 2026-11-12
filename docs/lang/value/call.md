# Call

Invokes a function — directly or through a pointer to function.

## Form

```
<#function#>(<#arguments#>)
<#pointer_to_function#>(<#arguments#>)
```

## Semantics

- Arguments are constructed implicitly to the parameter types
  (see [cons](./cons.md)).
- **Named arguments**: any argument may be passed as `name = value`,
  in any order; positional and named arguments may be mixed
  (`area(3, h = 4)`).
- Arguments are evaluated left to right in the order they are written —
  named ones too, whatever order the parameters are declared in (see
  [evaluation order](./README.md#evaluation-order)).
- Parameters with default values may be omitted
  (see [function definition](../def/func.md)).
- Variadic functions (`...`) accept extra arguments after the fixed
  ones, C-style.
- A pointer to function is called with the same syntax; the pointer
  variable must have type `*(...) -> T` (see [func](../type/func.md)).
- A call is an expression; calling a `Unit` function as a statement is
  the usual [value evaluation](../stmt/eval.md).
- A call to a **pure function** with compile-time arguments is a
  compile-time value — see [compile-time calls](#compile-time-calls).

## Compile-time calls

A function is pure when:

- its body is exactly one `return <expression>`;
- neither its parameters nor its result carry a reference outward
  (a pointer, a function, `__VA_List`, an `@extern` type — also when
  hidden in a record field, an array element or a variant), it has no
  `...` and its result is not `Unit`;
- the expression reads only parameters and constants and calls only
  pure functions — no variables, no dereference.

A call to a pure function whose arguments are all known at compile time
is folded into its value, exactly as if the expression were written in
place with the arguments substituted: the same width, overflow and
division rules as any [constant expression](./binary.md). The result can
be used wherever a compile-time value is required — a `const`, an array
size:

```modest
func square (x: Int32) -> Int32 {
	return x * x
}

const nine = square(3)          // 9, no call at run time
var buf: [square(3)]Int32       // [9]Int32
```

An error in the folded value — division by zero, overflow — is reported
at compile time at its place in the function body, followed by the call
it came from.

For now only scalar arguments and results are folded; a call with a
record or array argument or result stays a run-time call.

`@impure` (see [annotations](../annotation.md)) marks a function as not
pure, so its calls always happen at run time. Tests use it for identity
helpers that hide a value from the compiler:

```modest
@impure
func opaque (n: Int32) -> Int32 {
	return n
}
```

## Examples

```modest
func area (w: Int32, h: Int32 = 1) -> Int32 {
	return w * h
}

let a1 = area(3, 4)              // positional
let a2 = area(h = 4, w = 3)      // named, any order
let a3 = area(5)                 // default h = 1

type Op = *(a: Int32, b: Int32) -> Int32
func add (a: Int32, b: Int32) -> Int32 { return a + b }

var op: Op = &add
let s = op(1, 2)                 // call through pointer
```

## See also

- [Function definition](../def/func.md), [Function type](../type/func.md)
