# Binary Operations

## Form

```
<#left#> <#operator#> <#right#>
```

| Group | Operators | Operand types | Result |
| :-- | :-- | :-- | :-- |
| Equality | `==` `!=` | Bool, IntX, NatX, WordX, CharX, FloatX, arrays, records, pointers | `Bool` |
| Ordering | `<` `>` `<=` `>=` | IntX, NatX, FloatX | `Bool` |
| Arithmetic | `+` `-` `*` `/` `%` | IntX, NatX, FloatX (`%`: integers only) | operand type |
| Logical | `and` `or` | Bool | `Bool` |
| Bitwise | `&` `\|` `^` | WordX | operand type |
| Shift | `<<` `>>` | left: WordX; right: NatX or a non-negative integer literal | left type |

## Semantics

- **Operand types must match exactly** — there are no implicit numeric
  promotions: `Int32 + Int64` is an error (`different types ... in
  operation`). Construct to a common type explicitly. Generic literals
  adapt to the other operand: `i + 1` works for any integer `i`.
- Shifts do not apply to a bare literal: its width is only what its
  value needs, and a shift moves bits out of it or into bits it does not
  have. `1 << 4` is an error — give the
  literal a type first: `Word32 1 << 4`. A literal next to a `WordX` is
  fine (`w & 0x0F`), it takes `w`'s type.
- A pair of literals under `&`, `|` or `^` is fine: each bit of the result
  depends only on the same bit of the operands, so no width is needed.
  `0x0F | 0x30` folds into the literal `0x3F`, which then adapts to what
  it meets like any other literal — `const mask: Word8 = 0x0F | 0x30`.
- The only exception is shift: the right operand's type may differ from
  the left's. It is a count, not a bit pattern — a `WordX` or `IntX`
  operand, and a negative literal, are all rejected with `expected
  natural or non-negative integer value`.
- Equality extends to composites: arrays and records compare element- /
  field-wise, pointers compare addresses (`p == nil`).
- No ordering on `Char`, `Word`, `Bool`, pointers.
- There is no `xor` keyword: exclusive-or is `^` (Word). `and` / `or`
  are Bool-only.
- Division of integers truncates toward zero, and `%` is the remainder
  that truncation leaves — its sign follows the dividend: `-10 / 3` is
  `-3` and `-10 % 3` is `-1`.
- Which division you get is decided by the operands, not by where the
  result goes: `22 / 7` is `Integer / Integer` and folds to `3` even
  under `const x: Float64`. Write `22.0 / 7` to divide as `Rational`.

## Examples

```modest
var a: Int32 = 10
var b: Int32 = 3
let q = a / b                  // 3
let r = a % b                  // 1

const whole: Float64 = 22 / 7    // 3.0 — both operands are Integer
const exact: Float64 = 22.0 / 7  // 3.142857… — one operand is Rational

var w: Word8 = 0x0F
let m = (w << 4) | (w & 0x3)   // bit manipulation

let inRange = x >= lo and x <= hi

var h1, h2: [32]Word8
// ...
if h1 == h2 { printf("hashes match\n") }
```

## See also

- [Unary operations](./unary.md), [Construction](./cons.md)
- [Operator precedence](./README.md#operator-precedence)
