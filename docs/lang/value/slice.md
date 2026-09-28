# Slice

Selects a contiguous sub-array `[from, to)`.

## Form

```
<#array_value#>[<#from#> : <#to#>]
<#pointer_to_array#>[<#from#> : <#to#>]
```

## Semantics

- `a[i:j]` denotes elements `i` .. `j-1`; its length is `j - i`.
- Works on arrays and pointers to arrays (auto-deref).
- A slice can be an assignment target: `a[1:4] = [3]Int32 [1, 2, 3]`
  copies elements into the range.
- The result is itself an array value, so index, slice and field access
  continue on it: `a[1:4][0]` is the slice's first element, `a[1:5][1:3]`
  a slice of a slice.
- An unsized array of unsized arrays cannot be sliced
  (compiler message: `cannot slice array of an unsized array`).
- Bounds known at run time are not checked: outside
  `0 <= from <= to <= len` the behavior is undefined
  (UB#1, [`UB.md`](../../UB.md)).

## Examples

```modest
var a: [5]Int32 = [1, 2, 3, 4, 5]
let mid = a[1:4]              // [2, 3, 4]
let second = a[1:4][1]        // 3
a[0:2] = [2]Int32 [9, 9]
```

## See also

- [Index](./_index.md), [Array type](../type/array.md)
