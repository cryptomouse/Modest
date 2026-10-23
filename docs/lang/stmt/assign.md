# Assignment Statement

Stores a value into an lvalue. Assignment is a statement, not an
expression — it produces no value and cannot be chained.

## Form

```
<#lvalue#> = <#value_expression#>
```

## Lvalues

```modest
x = 10                   // variable
arr[i] = 10              // array element
arr[1:4] = [3]Int32 [1, 2, 3]   // slice (copies elements)
p.field = 10             // record field (auto-deref through pointer)
*p = 10                  // pointed-to value
```

The right-hand side is implicitly [constructed](../value/cons.md) to the
lvalue's type; incompatible types are an error.

The target is evaluated before the value: in `a[i()] = f()`, `i()` runs
first (see [evaluation order](../value/README.md#evaluation-order)).

## Compound assignment

```
<#lvalue#> <#op#>= <#value_expression#>
```

`op` is one of `+ - * / % & | ^ << >>`. `x op= y` means `x = x op y`, with
`x` evaluated **once**:

```modest
var i: Nat32 = 0
while i < n {
	i += 1               // there is no `++` / `--`
}

w |= 0x80                // w: Word8
arr[next()] += 10        // next() is called once
```

- The operator follows its own rules unchanged — both sides one type
  (a literal adopts the type of the lvalue), `& | ^ << >>` on `Word*` only,
  a shift count `NatX` or a non-negative literal — and reports the same
  errors as the long form.
- The result keeps the lvalue's type: `w <<= 1` on a `Word8` drops the
  high bit.
- An array is not a target: `+` on arrays is a compile-time concat.
- Like `=`, an operator at the end of the line continues the statement
  onto the next one.

`++x` and `--x` are no longer part of the language; the compiler rejects
them with `` `++` was removed, write `x += 1` ``.

## Notes

- `let` bindings, constants and function parameters are not assignable.
