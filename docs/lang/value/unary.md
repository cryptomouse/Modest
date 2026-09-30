# Unary Operations

## Form

```
<#operator#> <#value_expression#>
```

| Operator | Operand | Result | Meaning |
| :-- | :-- | :-- | :-- |
| `not` | Bool | Bool | logical negation |
| `~` | WordX | operand type | bitwise inversion |
| `-` | IntX, FloatX, FixedX, Integer, Rational | operand type | arithmetic negation |
| `+` | IntX, FloatX, FixedX, Integer, Rational | operand type | no-op |
| `&` | mutable value or function | pointer | address-of |
| `*` | pointer | pointee | dereference |

## Semantics

- Each operator takes one class of operand and no other. `not` is the
  Bool operator and `~` is the Word one — they are not two spellings of
  one thing, and neither crosses to the other's type. `-` and `+` take a
  number: `IntX`, `FloatX`, `FixedX`, or one of the compile-time literal
  types `Integer` and `Rational` — so `-5` and `-1.5` are negated before
  they ever reach a concrete type. `~` on a literal inverts it at the
  literal's own width — the fewest bits that hold its value, never fewer
  than one ([generic](../type/generic.md)) — and gives a literal again:
  `~0xA5` is `0x5A`, `~0x10` is `0x0F`, `~0` is `1`. The literal's top
  bit is always set, so `~` always clears it: `~0x0F` and `~0xFF` are
  `0`, unlike in C. The result never grows past that width, so
  `var m: Word32 = ~0xA5` is `0x0000005A`; for a full-width mask give the
  literal its type: `~Word32 0xFF` is `0xFFFFFF00`. The result may be
  narrower, and a second `~` works at that width: `~~0xA5` is `0x25`.
  A negative literal has no such width and is refused
  (`expected non-negative integer value`).
- So `-` requires a *signed* type: negating a `Nat` is an error
  (`expected value with signed type`). It is not defined on `WordX`
  either — a bit pattern is not a quantity, the same split
  [binary](./binary.md) draws for arithmetic and ordering.
- Any other operand is refused with `unsuitable value type '<T>' for
  '<op>' operation` — the same diagnostic the binary operators give.
  `+` goes through the signedness check too, so `+n` on a `NatX` is
  `expected value with signed type`, like `-n`.
- `&` applies to mutable values (variables, fields, elements) and
  functions. Immutable values — `let` bindings, parameters,
  constants — have no address (`expected mutable value or function`).
- `*p` designates the pointed-to value (a place): readable, assignable
  (`*p = 10`). Records and arrays behind pointers are accessed without
  explicit `*` — see [pointer](../type/pointer.md).
- `new` is parsed as a unary operator but is experimental — do not use.

## Examples

```modest
var flag: Bool = false
flag = not flag

var mask: Word8 = 0x0F
mask = ~mask                  // 0xF0

var x: Int32 = 5
let neg = -x

var p: *Int32 = &x
*p = 10                       // x == 10
```

## See also

- [Pointer type](../type/pointer.md), [Binary operations](./binary.md)
