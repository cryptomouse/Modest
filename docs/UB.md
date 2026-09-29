# Undefined Behavior

Cases the language deliberately leaves undefined: a program that reaches one
of them has no meaning, and the compiler is not required to diagnose it —
neither at compile time nor at run time.

An entry here is `UB#3`, the tag its heading carries, the same way a bug is
`BUG#20`, a doubt is `DOUBT#2` and an undecided design question is
`QUESTION#4` (`docs/lang/QUESTIONS.md`).  Numbers are permanent: never
reused, never renumbered.

This page is part of the language contract, not a list of defects:

| Situation | Where it goes |
| :-- | :-- |
| the language decided not to define this case | here |
| the program is valid Modest, but a backend emits C/LLVM UB for it | [`BUGS.md`](BUGS.md) |
| nobody has decided yet whether the case is defined | [`QUESTIONS.md`](lang/QUESTIONS.md) |

So "the generated C happens to be UB" is never on its own a reason for an
entry here — it is a bug until the language says otherwise.

Each entry gives the Modest code, why the case is left undefined, what each
backend actually does today, how to avoid it, and what could catch it.
A check that catches a case (e.g. at compile time, when the operands are
constants) is guarded by a regular test marked `Covers UB#N`.

---

## UB#1: Slice bounds that are not `0 <= from <= to <= len`, known only at run time

```modest
var a: [5]Int32 = [10, 20, 30, 40, 50]
var i: Nat32 = 3
var j: Nat32 = 1
let r = a[i:j]      // to < from
let e = a[i:i]      // empty
let o = a[2:j + 9]  // past the end
```

- Why undefined: a slice is a copy of `to - from` elements; checking the
  bounds would cost a comparison and a trap path on every run-time slice,
  which the language does not pay for implicitly.
- When the bounds are constants the compiler does check them:
  `to < from` is `wrong slice direction`, `to == from` is `empty slice`
  (a zero-length array is not a type, `var x: [0]T` is refused too), a
  negative bound is `slice index must be non-negative`, and a bound past
  a known length is `slice index out of bounds`.  One constant bound is
  checked on its own even when the other is known only at run time
  (`a[-1:i]`, `a[9:i]` on an `[8]T`).
- C11: the slice is materialized as a VLA, `int32_t r[j - i];`, then
  `memcpy`'d from `&a[i]`.
  - `to == from` — VLA of size 0: UB (C11 6.7.6.2p5, size must be > 0).
  - `to < from` — with signed bounds the size is negative: UB; with `NatX`
    bounds `j - i` wraps to a huge size: stack overflow in practice.
  - `to > len` — the `memcpy` reads past the end of `a`.
- LLVM: run-time-bounded slices are not usable yet regardless of the
  bounds — see BUG#75, BUG#76, BUG#77.
- Avoid: check the bounds before slicing, or take a pointer instead of a
  copy (`&a[i:j]` emits `&a[i]` and allocates nothing).
- Could be caught by: a run-time bounds check under an opt-in flag.
- See: [`lang/value/slice.md`](lang/value/slice.md)

## UB#2: An array index outside `0 <= i < len`, known only at run time

```modest
var a: [5]Int32 = [10, 20, 30, 40, 50]
var i: Int32 = 5
var n: Int32 = -1
let x = a[i]        // one past the end
a[n] = 0            // before the start
let p = *[]Int32 &a
p[7] = 0            // `*[]T` has no length to check against
```

- Why undefined: the same trade as UB#1 — a bounds check would put a
  comparison and a trap path on every run-time index, and the language
  does not pay for it implicitly.  An index is a place, so reading it,
  writing it and `++` on it are all affected alike.
- When the index is a constant the compiler does check it: a negative one
  is `array index must be non-negative`, and one that reaches a known
  length is `array index out of bounds` — for a variable, a field, an
  element of a multi-dimensional array, a pointer to a sized array and a
  slice with constant bounds.  A pointer to an unsized array (`*[]T`) has
  no length, so there only the sign is checked.
- C11: plain subscript, `a[i]`.  Outside the array it is UB (C11 6.5.6p8):
  a read returns whatever lies there, a write corrupts a neighbour.  A
  negative signed index is the same case; a `NatX` index holding a
  "negative" value is a huge offset instead.
- LLVM: `getelementptr [N x T], ptr, 0, i` (no `inbounds`, so computing
  the address is defined), then `load`/`store` through it — an access
  outside the object is UB, same outcome as in C.
- Avoid: check the index before using it, or iterate with a counter that
  is bounded by `lengthof(a)`.
- Could be caught by: a run-time bounds check under an opt-in flag, the
  same one as for UB#1.
- See: [`lang/value/_index.md`](lang/value/_index.md)
