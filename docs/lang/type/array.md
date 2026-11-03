# Array Type

An *array* is a fixed-length, contiguous sequence of elements of one
type, indexed from zero. An array is an ordinary value type — unlike C,
there is **no array decay**.

## Form

```
[<#length#>]<#element_type#>     // fixed array; length is a compile-time constant
[<#n#>]<#element_type#>          // variable-length array (VLA); n is a run-time integer, local only
[]<#element_type#>               // unsized array: length not part of the type
```

```modest
[10]Int32         // ten Int32
[2][3]Int32       // 2 x 3 matrix (array of arrays)
[]Char8           // unsized array of bytes/chars
*[]Int32          // pointer to unsized array
```

## Semantics

- Indexing: `a[i]`; slicing: `a[i:j]` (see [slice](../value/slice.md));
  element count: `lengthof(a)`.
- Multi-dimensional arrays are arrays of arrays: `m[1][2]`.
- An *unsized* array `[]T` carries no length in its type (C calls this
  an *incomplete array type*), so a variable of such type cannot be
  created — unsized arrays live behind pointers (`*[]T`) and as the
  pointed-to type of slices and strings. The opposite — `[N]T` — is a
  *sized* array.
- A pointer to array auto-derefs on indexing: with `p: *[10]Int32`,
  write `p[3]`, not `(*p)[3]` (see [pointer](./pointer.md)).
- **By value, everywhere**: arrays are passed to functions, returned
  from functions and assigned by value — the whole content is copied,
  the size is part of the type. An array never silently turns into a
  pointer. To share storage instead of copying, pass `*[N]T` / `*[]T`
  explicitly.
- Generic array literals convert implicitly at equal length; explicit
  construction to a longer array zero-fills the tail; `= []` zero-fills
  entirely (see [generic](./generic.md)).
- A typed array widens the same way, by explicit construction only:
  `[20]Nat32 a` with `a: [4]Nat32` keeps `a` in the head, the tail takes
  the element default. The element type must match, and it never
  shortens — use a slice `a[0:n]` (see [cons](../value/cons.md)).

## Variable-length arrays

A length that is not a compile-time constant makes a *variable-length
array* (VLA), as in C99. The length is any integer expression — a
variable of any `IntX` / `NatX` type, a call, arithmetic; a non-integer
one is `expected integral value`.

```modest
func fill (mem: *Unit, n: Nat32) -> Unit {
	var buf: [n]Word8                // n elements on the stack, zero-filled
	type Grid = [n][2 * n]Word8      // a named VLA type
	let rows = *Grid mem             // a pointer to one
	rows[1][7] = buf[n - 1]
}
```

- **Local only.** A VLA type may appear in a function body: a `var`,
  a `let`, a local `type`, a construction (`*[n]Int32 p`), `sizeof` /
  `lengthof`. Anywhere else it is `non local VLA are forbidden`:
  - a module-level `var`, `const` or `type`;
  - a function parameter or result — by value or through a pointer
    (`a: [n]Int32`, `p: *[n]Int32`, `-> [n]Int32`). A bound naming another
    parameter (`p: *[m]Int32` after `m: Nat32`) is `undefined value 'm'`.
    Pass a pointer to an unsized array and the length beside it instead:
    `func sum (v: *[]Int32, n: Nat32)`.
- **Not in a record, function type or variant.** Even in a function body
  a VLA may not be a record field, a parameter or result of a function
  type, or a variant member — by value or through a pointer — since there
  is no declaration to take its lengths at: `VLA in a record field is
  forbidden` (likewise `in a function type`, `in a variant`). Arrays and
  pointers may wrap a VLA: `[i][j]T`, `[3][n]T`, `*[n]T`. And the
  other way round is fine — an array of records `[n]Point`, or a record
  holding `*[]Int32`.
- **The length is taken once, where the declaration runs.** A local
  `type`, `var` or `let` evaluates its bounds at that point, and the type
  keeps those values for the rest of its scope — as `typedef` and VLA
  declarations do in C. Changing the variables afterwards changes neither
  the size nor the layout, and a bound with side effects runs once:

  ```modest
  var k: Nat32 = 10
  type Row = [k]Nat32
  var a: [k]Nat32
  k = 0
  sizeof(Row)        // 40
  lengthof(a)        // 10
  ```

  A VLA type written inside an expression (`sizeof([k]Nat32)`, a
  construction passed straight to a call) is evaluated where it stands.
  Each declaration takes its own values: a `type` redeclared in a nested
  block, or a second `var a: [k]Nat32` after `k` changed, gets the bounds
  current at *its* declaration.
- `sizeof` and `lengthof` of a VLA are a run-time `Size` (see
  [sizeof](../value/sizeof.md)); indexing and slicing work as for any
  array. Only some dimensions may be run-time, in any position:
  `[n][3]Int32`, `[3][n]Int32`.
- **Initialization.** A VLA variable starts zero-filled; `= []` says the
  same explicitly. A generic array literal goes into a VLA in a `var`, a
  `let`, an assignment or an explicit construction (`[n]Int32 [1, 2]`),
  and so does a literal of rows into an array with a VLA inside
  (`[2][n]Int32`, `[n][m]Int32`). Its lengths are known at compile time
  and the VLA's only at run time, so the lengths are not compared: at
  every level as many items are copied as both have, and the rest is
  zero-filled — nothing is read or written past either end. Whether a
  literal of another length should be an error is not decided yet —
  QUESTION#7. A row that is a VLA value rather than a literal
  (`[r, r]`) is not supported yet — BUG#116.
- **A VLA and a fixed array are different types**, even when the lengths
  happen to be equal: their lengths could only be compared at run time.
  Neither is copied into the other — not by assignment, initialization,
  argument passing, nor explicit construction (`[4]Int32 vla`) — and a
  pointer to one is not a pointer to the other (`*[n]T` vs `*[4]T`, the
  same as `*[5]T` vs `*[4]T`).  Go through a slice, whose length is
  stated where it is written:

  ```modest
  var vla: [n]Int32
  var fixed: [4]Int32
  fixed = vla              // error: cannot implicitly construct `[4]Int32` from `[n]Int32`
  fixed = vla[0:4]         // ok
  vla[0:4] = fixed         // ok
  ```

- Two VLAs are copied into each other by value, like any array; their
  lengths are not compared — QUESTION#7.

## Strings

String types are built-in aliases for unsized char arrays:

```modest
// built-in definitions
type Str8  = []Char8
type Str16 = []Char16
type Str32 = []Char32
```

A string literal is a `[N]CharX` array value containing exactly the
characters written. Zero-termination is a property of the string *types*
(`@zarray`, see `docs/TODO.md`), appended when a string value is
constructed — not part of the literal itself. A string is normally
handled through a pointer:

```modest
var s: *Str8 = "Hello World!\n"
printf(s)
let c = s[0]              // Char8 'H'
```

## Examples

```modest
func sum (v: *[]Int32, n: Nat32) -> Int32 {   // explicit by-reference
	var s: Int32 = 0
	var k: Nat32 = 0
	while k < n { s += v[k]; k += 1 }
	return s
}

func maxOf (v: [5]Int32) -> Int32 {           // parameter by value
	var m: Int32 = v[0]
	var k: Nat32 = 1
	while k < lengthof(v) {
		if v[k] > m { m = v[k] }
		k += 1
	}
	return m
}

func makeTriple (x: Int32) -> [3]Int32 {      // returned by value
	var r: [3]Int32 = [x, x + 1, x + 2]
	return r
}

func main () -> Int {
	var a: [5]Int32 = [1, 2, 3, 4, 5]
	a[0] = 10
	printf("sum = %d\n", sum(&a, lengthof(a)))
	printf("max = %d\n", maxOf(a))    // a copied into the parameter

	var t: [3]Int32 = makeTriple(10)  // t = [10, 11, 12]

	var b: [5]Int32 = []              // zero-filled
	b = a                             // copy by value
	return 0
}
```

<details>
<summary>C output (c11 backend)</summary>

```c
static int32_t sum(int32_t *v, uint32_t n) {
	int32_t s = 0;
	uint32_t k = 0;
	while (k < n) {
		s = s + v[k];
		k = k + 1;
	}
	return s;
}

static int32_t maxOf(int32_t *_v) {
	int32_t v[5];
	__builtin_memcpy(v, _v, sizeof(int32_t [5]));
	int32_t m = v[0];
	uint32_t k = 1;
	while (k < LENGTHOF(v)) {
		if (v[k] > m) {
			m = v[k];
		}
		k = k + 1;
	}
	return m;
}

static void makeTriple(int32_t x, int32_t *__out) {
	int32_t r[3];
	__builtin_memcpy(&r, &(int32_t [3]){x, x + 1, x + 2}, sizeof(int32_t [3]));
	__builtin_memcpy(__out, &r, sizeof(int32_t [3]));
}

int main(void) {
	int32_t a[5] = {1, 2, 3, 4, 5};
	a[0] = 10;
	printf("sum = %d\n", sum(a, LENGTHOF(a)));
	printf("max = %d\n", maxOf(a));
	int32_t t[3];
	makeTriple(10, t);
	int32_t b[5] = {0};
	__builtin_memcpy(&b, &a, sizeof(int32_t [5]));
	return 0;
}
```

Note how the *value semantics* survives the translation: a by-value
parameter becomes a pointer + a local copy (`maxOf`), array return
becomes an out-parameter + `memcpy`, assignment becomes `memcpy` — the
copying is real, only expressed in C terms.

</details>

## See also

- [Slice](../value/slice.md), [Index](../value/access.md)
- [sizeof / lengthof](../value/sizeof.md)
