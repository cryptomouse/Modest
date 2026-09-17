# Constant Definition

Binds an [identifier](../identifier.md) to a compile-time value. A constant
occupies no storage; its value is substituted at each use site.

## Form

```
const <#identifier#> = <#value_expression#>
const <#identifier#>: <#type_expression#> = <#value_expression#>
```

## Semantics

- The initializer must be evaluable at compile time. A runtime value is an
  error: `expected immediate value`.
- Without a type annotation the constant keeps the *generic* type of its
  initializer (`Integer`, `Rational`, `String`, ...) and adapts to the
  required concrete type at each use site (see
  [generic types](../type/generic.md)).
- With a type annotation the value is implicitly
  [constructed](../value/cons.md) to that type at the definition.
- Constants may be defined at module level and inside functions.
- A `public const` must have a non-generic type: `expected immediate value`
  applies to the initializer as usual, but on top of that a generic type
  (`Integer`, `Rational`, `String`, ...) is rejected with `public constant
  must have a non-generic type`, since a generic type only adapts at each
  use site within the module and has no single concrete representation to
  export. Give the constant an explicit type annotation, or construct a
  branded value, to make it concrete. A private/default constant may keep
  a generic type.
- For immutable *runtime* bindings inside functions use
  [`let`](../stmt/let.md).

## Examples

```modest
const one = 1                  // generic Integer
const two = one + 1            // constant expressions fold
const pi: Float64 = 3.14159    // concrete type
const message = "Hello!\n"

const a: Int8 = one              // Integer adapts to Int8
const b: Nat64 = one             // ... and to Nat64

public const answer: Int32 = 42  // public + explicit type: concrete, OK
public const bad = 42            // error: public constant must have a non-generic type
```
