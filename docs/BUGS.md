# Known Bugs

Found 2026-06-11 while verifying documentation against the compiler
(merged 2026-07-29 with the older, previously-duplicated root-level BUGS.md).

This file is the only place bugs are recorded, so a bug is referred to as
`BUG#N` everywhere — docs, source comments, test `EXPECTED-FAIL` markers,
commit messages — without naming the file.  The number is permanent: an entry
is deleted when the bug is fixed, and numbers are never reused.

Nothing is kept here about fixed bugs.  What survives a fix is the test that
reproduced it: its `EXPECTED-FAIL` marker becomes a `Guards BUG#N (fixed
<date>)` line, so the number still leads to its reproducer (`tests/README.md`,
"Known-broken tests").  Who fixed it and when is git's to answer:
`git log -S '## BUG#N:' -- docs/BUGS.md`.

## BUG#15: C backend's `#include` of its own header ignores `-o`

```sh
modest -o out/prog -mbackend=c11 main.modest
# writes out/prog.c and out/prog.h, but out/prog.c contains:
#include "main.h"        # does not exist -> clang: file not found
```

- Cause: the include line is built from the module id (`include(module.id
  + '.h')`, `src/backend/c11.py:2161`), which is the *source* base name,
  while the header file is written as `os.path.basename(_outname) + '.h'`
  (`src/backend/c11.py:2282`) — the *output* prefix. The two agree only
  when `-o` happens to end in the same base name as the source.
- Expected: both should come from the same name.
- Went unnoticed because every existing invocation follows the
  `-o <dir>/main main.modest` shape, where the two coincide.

## BUG#19: `-funsafe` is never consulted; only `pragma unsafe` grants permission

```bash
modest -o out -mbackend=c11 -funsafe main.modest   # module has no pragma unsafe
```

```
error: for use 'unsafe' operator required -funsafe option
```

- The diagnostic names the flag the user just passed. Permission is granted
  solely by `pragma unsafe` in the module: `do_value_unsafe`
  (`src/semantic.py:1783`) tests only `cmodule.hasAttribute('unsafe')`.
- The `features` list that `-f<name>` fills in (`src/main.py:58`) is read in
  exactly one place — `'paranoid' in features` (`src/error.py:142`, `:152`).
  Nothing ever asks it about `unsafe`, so the flag is dead for this purpose.
- The `-funsafe` in the example Makefiles (`examples/crc32`, `examples/sha256`,
  `examples/xxh64`) is a no-op; those modules compile because of their pragma.
- Open question, not just a wording fix: is the command line supposed to be a
  second, independent way to opt in (then wire `features` into the check), or
  is `pragma unsafe` the only intended door (then drop `-funsafe` and reword
  the diagnostic to name the pragma)? Unsafe is expected to be reworked, so
  settle this as part of that.
- Docs updated to match the current behaviour: `docs/CHEATSHEET.md`
  (construction rules), `docs/lang/value/cons.md`, `docs/USAGE.md`.

## BUG#23: Breaking the line-continuation rule gives a diagnostic that does not teach it

```modest
let v = a
	| (a << 8)      // error: unexpected token '|'
```

```modest
let v = a |
return 0            // error: undefined value 'return'
```

- Both messages are technically true and practically useless: neither mentions
  that a continued expression must end the line with its operator.
- Wanted: for a binary operator at the start of a line — "binary operator at
  start of line; to continue an expression, put it at the end of the previous
  line". For a trailing operator with nothing to continue into — point at the
  operator, not at the innocent token on the next line that got swallowed.

## BUG#25: `FixedX` — the gaps left around a working type

The scale itself is right everywhere now: constant folding, run-time
construction and run-time `*` and `/` all apply it, in both backends.  What
is listed here is what still surrounds that.

Constant folding of `FixedX` is implemented: literals, `const`s, arithmetic
between them, array elements, `@fraction(N)` and every construction into and
out of `FixedX` apply the scale. A `FixedX` value stores the number multiplied
by `2^fraction`; the `asset` of an HLIR value with a `FixedX` type is that raw
storage, and `src/value/fixed.py` is the only place the scale is applied or
removed. Rounding is to the nearest representable step, a half step going away
from zero. Covered by `tests/lang/type/fixed/comptime.modest`.

Run-time arithmetic and construction apply and remove the scale too, in both
backends: `*` and `/` correct it through the `__fixedX_mul` / `__fixedX_div`
helpers (`do_cvalue_fixed_bin` in `src/backend/c11.py`, `llvm_eval_fixed_bin`
against the `fixed_helpers_impl` blob in `src/backend/llvm.py`), while `+`,
`-` and the comparisons need no correction — the scale cancels itself there.
Construction works in every direction the construction table allows — `IntX`,
`FloatX` and a `FixedY` with a different `@fraction`, with `WordX` staying the
raw storage on purpose. C11 goes through the `__fixedX_*` helpers, LLVM prints
the equivalent instructions; both round like the fold.

One deliberate exception, taken for the sake of readable C: where the operand
is a plain literal or a `const`, the C backend emits `FIXED32(1.5, 16)` rather
than the folded number (`fixed_cons_via_macro`, `src/backend/c11.py`). The
macro scales in `double` while the fold is exact, so the two disagree by one
LSB whenever the value needs more than 53 significant bits — reachable only
on `Fixed64`, where the fraction is 32 by default:

```c
FIXED64(1312230.071214217469, 32)   // C:    0x001405e6123b1850
                                    // fold: 0x001405e6123b184f  (LLVM emits this)
```

`Fixed32` can never hit it (32-bit storage against a 53-bit mantissa). Roughly
1 in 50000 random 12-decimal `Fixed64` literals diverges. Emitting the folded
number everywhere removes it — that was the behaviour until 2026-08-23, traded
away for output that reads like the source.

Two constraints on that macro, both load-bearing: it must stay a *constant
expression* (it lands in static initializers, so no function call inside), and
because that forces it to evaluate `(x)` twice, codegen must never hand it an
expression with side effects — run-time values go through
`__fixedX_from_float64` instead.

What is left:

- `Fixed64` multiplication and division need a `__int128` intermediate, which
  exists only on 64-bit targets; those four C helpers sit under
  `#ifdef __SIZEOF_INT128__`, so a module that uses `Fixed64 *` or `/` on a
  32-bit target fails to compile. The LLVM backend does not share the problem:
  `i128` is a native IR type there.
- The `modest` backend drops the annotation's argument: `@fraction(12)
  Fixed32` comes back out as `@fraction Fixed32`. It only has to survive
  codegen, so the tests pass there — but the emitted source silently loses
  the binary point. Same class as the backend's other round-trip gaps.

Coverage: `tests/lang/type/fixed/runtime.modest` (run-time) and
`tests/lang/type/fixed/comptime.modest` (compile-time); both pass under c11 and
llvm.

## BUG#50: C backend emits an identifier that is a C keyword as it stands

```modest
var double: Int32 = 2
var switch: Int32 = 1
```

```c
int32_t double = 2;    // error: cannot combine with previous declaration specifier
int32_t switch = 1;
```

- Modest's keywords are not C's, so a perfectly ordinary name — `double`,
  `switch`, `case`, `int`, `union`, `register` — reaches the C backend as
  an identifier and is written out unchanged. The generated translation
  unit does not compile, and the diagnostic points at C the author never
  wrote.
- Functions, variables and fields are all affected.
- The LLVM backend is unaffected: its identifiers are prefixed and quoted
  where they need to be.
- Fix: mangle any identifier that is a C keyword on the way out, the way
  the backend already mangles what it has to.
- No reproducer in the suite.

## BUG#51: A type named after a builtin redefines it in the LLVM backend

```modest
type Size = {w: Int32, h: Int32}
```

```llvm
%Size = type i64        ; the prelude's
%Size = type { ... }    ; error: redefinition of type
```

- `Size` is a builtin type name, and the front end lets a module define
  its own without a word: inside that module the user's `Size` wins, and
  `var n: Size = sizeof(Int32)` is reported as `type mismatch Size &
  Integer(8)` — which is the shadowing working as the front end sees it.
- The LLVM backend then emits the user's type under the same `%Size` the
  prelude already defines, and clang refuses the file. Every builtin type
  name is a candidate: `Size`, `Byte`, `Bool`, `File`, `Str8`.
- The C backend is unaffected: it lowercases record tags, so `struct
  size` does not collide with `size_t`.
- Fix: either reject a definition that shadows a builtin type, or emit
  user types under names that cannot collide with the prelude's.
- No reproducer in the suite.


## BUG#54: An empty record type is emitted as `void` in an initializer

```modest
type Empty = {}
var e: Empty = {}
```

```c
struct empty {uint8_t __placeholder;};
static struct empty e = (void){0};   // error: variable has incomplete type 'void'
```

- The type is declared as a real struct with a placeholder byte, but
  `do_cvalue_cons_record` (`src/backend/c11.py:700`) treats an empty
  record as `Unit` and casts its initializer to `void`. The declaration
  and the initializer disagree, and the translation unit does not
  compile.
- The two views of an empty record need to agree: either it is `Unit` and
  gets no storage, or it is a struct and its initializer is `{0}` under
  the struct's own type.
- No reproducer in the suite: `tests/lang/type/record/` has no empty-record
  case.

## BUG#56: A named variant type crashes the C backend

```modest
type Err = @branded Nat32
type Res = Int32 or Err     // never used
```

```
TypeError: can only concatenate str (not "NoneType") to str
```

- `do_ctype_variant` (`src/backend/c11.py:240`) builds the C name from
  `t.c_anon_id`, which is `None` until something assigns it — nothing
  does for a variant reached through a `type` definition, and the
  definition alone is enough to crash: the type need not be used.
- The LLVM backend accepts the same file — but it does not lower a
  variant at all (`eval_cons_or`, `src/backend/llvm.py:1612`, is a bare
  `1/0`), so nothing that uses one gets past it either.
- Experimental type. `tests/lang/type/variant/basic.modest` covers what does
  work and spells the type out inline to stay clear of this.

## BUG#57: Each written-out variant type becomes its own C struct

```modest
func divide (a: Int32, b: Int32) -> Int32 or Err { ... }

var r: Int32 or Err = divide(10, 2)
```

```c
struct main__anonymous_variant_0 {uint8_t tag; union {int32_t _0; Err _1;} value;};
struct main__anonymous_variant_1 {uint8_t tag; union {int32_t _0; Err _1;} value;};
...
struct main__anonymous_variant_1 r = divide(10, 2);
// error: initializing 'struct main__anonymous_variant_1' with an expression
//        of incompatible type 'struct main__anonymous_variant_0'
```

- Every occurrence of the same variant type is emitted as a fresh
  anonymous struct, so two spellings of one type do not match in C. The
  language has structural types; the C output makes them nominal, and
  identical variants stop being the same type.
- The same across modules: a public function of `geo` returning
  `Point or Id` gives `struct geo__anonymous_variant_N`, and an importer
  that writes `var r: geo.Point or geo.Id = geo.pick(...)` gets its own
  `struct main__anonymous_variant_M` for it — the same error.
- Anonymous *records* have the same two-structs shape and get away with
  it: an assignment between structurally equal records goes through
  `RAWCAST` (`do_cvalue_cast_raw`).  Variants have no such conversion — either
  give them one, or emit one struct per distinct variant (a name derived
  from the members, defined under an `#ifndef` so that two headers can
  both carry it).
- The natural way to write this — name the type once and use the name —
  is BUG#56, so both spellings of a shared variant type are currently
  unusable and only a value inferred from the call (`let r = divide(...)`)
  gets through.
- Coverage: `tests/lang/type/variant/basic.modest` holds the working shape and
  points here.

## BUG#68: `-o` renames the generated files but not the module inside them

```sh
modest -o zzz -mbackend=c11 xxh64.modest
```

```c
/* zzz.c */
#include "xxh64.h"

/* zzz.h */
#if !defined(XXH64_H)
#define XXH64_H
```

- The C11 backend writes `zzz.c` and `zzz.h` as asked, but names the module
  after the source file: the self-include and the include guard both say
  `xxh64`. The `.c` then includes a header that was never written, and clang
  stops at `'xxh64.h' file not found`.
- The reverse case is worse, because it is silent. Two modules whose sources
  share a basename — a test `prog/crc32.modest` linked against
  `lib/misc/crc32.modest` — generate the same guard `CRC32_H` whatever `-o`
  calls the files. The second header to be included is skipped entirely, and
  the program links only if it happens not to need the declarations that were
  dropped.
- So the name a module is known by is the source filename, and `-o` cannot
  change it. Either the module name should follow `-o`, or it should be the
  import path (`misc/crc32`), which is unique by construction.


## BUG#71: `@alignment(N)` on a record type loses its N

```modest
type Aligned = @alignment(2) {
	a: Word8
}

alignof(Aligned)   // c11: 16   llvm: 1   expected 2
sizeof(Aligned)    // c11: 16   llvm: 1   expected 2
```

```c
struct aligned {
	uint8_t a;
};
```

- The argument is dropped in `Type.copy_with_atts`
  (`src/hlir/types.py:685`), which stores every type attribute as
  `nt.addAttribute(k, {})` — the fact of the attribute and nothing else.
  `alignment` is the one type attribute that carries a number, and
  `str_gcc_attributes` prints an argument only when the stored value is not
  `{}`, so nothing is left to print but a bare `aligned`.
- Which is why the C backend drops the attribute instead of emitting it
  (`record_c_attributes`, `src/backend/c11.py:236`): bare `aligned` does
  not mean "as written without it" — it asks for the largest alignment the
  target uses for any type, so a record asking for 2 would come out
  16-aligned and 16 bytes long, further from what was written than saying
  nothing. The position is not the problem: a record's attributes are
  printed after the closing brace, where a compiler reads them for a
  struct type.
- The frontend does not read the attribute either: `calc_record_size_align`
  takes the record's alignment to be the largest of its fields', so
  `alignof` and `sizeof` answer as if the attribute were not written. It
  now knows about `@layout`, and `@alignment` is the same kind of thing
  said about the same record — the layout it computes has to answer for
  both.
- `@alignment` on a `var` is unaffected — it goes through a different path
  (`src/semantic.py:3263`) that keeps the argument, and the LLVM backend
  reads it back at `src/backend/llvm.py:2857`.
- No reproducer in the suite. What is pinned there is the blast radius:
  `tests/lang/type/record/layout.modest` checks that a record asking for 2
  is never *more* than 2 bytes, which holds while the annotation is dropped
  and holds once it is honoured, and fails the moment a bare `aligned`
  reaches the C output again.

## BUG#72: C backend loses a layout added to an already named record, outside a `type` alias

The `type Packed = @layout("packed") Padded` form is fixed (2026-09-13,
`tests/lang/type/record/layout_alias.modest`) — see below for what remains.

```modest
type Padded = {
	tag: Word8
	len: Nat32
}

func f (v: @layout("packed") Padded) {
	sizeof(v)          // c11: 8    llvm: 5
	offsetof(v.len)     // c11: 4    llvm: 1
}
```

```c
struct padded {
	uint8_t tag;
	uint32_t len;
};

void f(struct padded v) { ... }   /* the padded one, unpacked */
```

- Writing a layout against a record that already has a name asks for its
  fields laid out another way — two types over one field list. The frontend
  reads it that way: `copy_with_atts` makes a copy of the record and lays it
  out again, and the LLVM backend prints the packed type from it correctly
  wherever it appears.
- `do_def_type` (the `type X = ...` alias declaration) now special-cases
  this: whenever the aliased type is named *and* carries its own
  `ast_annotations` (`@layout`, `@alignment`, ...), it prints a full struct
  literal tagged with the alias's own name instead of a `typedef` to the
  original tag — `do_def_type_record` emits both the forward `typedef` and
  the tagged definition, gated on `is_open_access` (not `is_open_record`:
  an alias needs the C name even when every field stays private).
- What is still lost is any *other* position that carries such an
  annotation directly on a named type reference — a `var` type, a function
  parameter or return type, a field type — since those go straight through
  `do_ctype`/`do_ctype_named`, which only ever prints the plain tag
  (`struct padded`) and drops the annotation. There is no declaration site
  there to hang a second struct off, unlike a `type` alias.
- Whether the language wants this at all outside a named alias is worth
  settling first: one record, one layout is a defensible rule, and then
  this is a diagnostic to write rather than a backend to teach.
- Coverage: `tests/lang/type/record/layout_alias.modest` covers the fixed
  `type` alias form (both `packed` and, per `src/backend/c11.py`'s
  `do_def_type`, `union`). No reproducer yet for the remaining `var`/field/
  parameter case.

## BUG#74: constructing across differing `@layout` evaluates the source once per field

```modest
type Exact = {tag: Word8, len: Nat32}
type Packed = @layout("packed") {tag: Word8, len: Nat32}

func makePacked () -> Packed {
	printf("called\n")
	return {tag = 1, len = 2}
}

func main () -> Int {
	var e = Exact makePacked()
	printf("%x %u\n", Nat32 e.tag, e.len)
	return 0
}
// expected: one "called"
// c11, llvm: two "called" - the second overwrites nothing visible here,
// but the call itself runs twice
```

- Both backends repack a layout-mismatched record field by field: for each
  field of the target type they build a `ValueAccessRecord` reading that
  field off the *same* source `Value` node and evaluate it on the spot -
  `do_cvalue_cast_layout` (`src/backend/c11.py:1000`) and
  `cons_record_repack_layout` (`src/backend/llvm.py:1576`, added fixing
  BUG#73) are the same shape by design, one mirroring the other.
- Neither hoists the source into a temporary first. When the source is a
  plain `var` or `const`, referencing it N times (once per field) is free -
  a name, not a computation - which is the case every existing test
  exercises. When it is anything with a side effect (a call, `new`, an
  assignment-yielding expression), that expression's *tree* is what gets
  referenced N times, and each field access re-evaluates it: the C backend
  prints the call once per field access it emits into the struct literal;
  the LLVM backend re-runs the whole nested construction (its own
  `eval_cons_record`) once per field, discarding every result but the one
  field it needed.
- Only the side effect count is wrong - each individual field value is
  still read correctly off its own (correct) evaluation, so nothing here
  corrupts a result the way BUG#73 did. Also unaffected: record *literals*
  (`{tag = .., len = ..}`) go through `value_record_cons`
  (`src/value/record.py:107`) instead, which resolves each field's value
  once at HLIR level and only ever emits it once.
- Fix belongs above the backend split, in `value/record.py` or wherever the
  `ValueCons` for a layout-mismatched record is built: bind the source to a
  temporary once (a `let`-like synthetic local, or a compiler-internal
  `ValueVar`) and have every field's `ValueAccessRecord` read off that
  instead of the raw source expression - one evaluation, N reads, in both
  backends at once.
- No reproducer in the suite yet - `layout_convert.modest` (BUG#73) only
  exercises `var` sources, which this does not affect.

## BUG#75: LLVM backend copies a slice with run-time bounds as `[0 x T]`

```modest
var a: [6]Int32 = [10, 20, 30, 40, 50, 60]
let i = opaque(2)
let j = opaque(5)
var s = a[i:j]                   // s[0] should be 30
a[i:j] = b[i:j]                  // should copy three elements
sum3(a[i:i + 3])                 // should pass a[2], a[3], a[4]
```

- Every read of such a slice as a *value* — into a `var`, into another
  slice, as a by-value argument, of a `let` bound to a call — comes out
  wrong: the target keeps its old contents or gets garbage. Writing *into*
  a run-time slice (a literal, `= []`) and `&a[i:j]` are fine, as is
  everything under `-mbackend=c11`.
- Cause: `do_eval_slice` (`src/backend/llvm.py:1341`) bitcasts the element
  pointer to a pointer to the slice's type, and a slice whose volume is not
  a constant becomes `[0 x %Int32]*`. The copy is then a `load` / `store`
  of `[0 x %Int32]` — zero bytes — into an `alloca %Int32, %n`:
  `%29 = load [0 x %Int32], [0 x %Int32]* %28`.
- Fix, probably: a VLA-typed slice has to be copied with `llvm.memcpy` and
  a run-time byte count (`(j - i) * sizeof(T)`), the way the C backend
  already does.
- Reproducer: `tests/lang/value/slice/runtime_value.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#84: LLVM backend sign-extends a `WordX`/`NatX` widened to a signed type

```modest
var w: Word8 = 0xff
var n: Nat16 = 65535
let a = Int32 w      // -1, expected 255
let b = Int32 n      // -1, expected 65535
```

```llvm
%6 = sext %Word8 %5 to %Int32
```

- Any run-time widening of an unsigned source (`WordX`, `NatX`) to a wider
  signed type (`IntY`) sign-extends, so every value with the top bit set
  comes out negative.  Locals, globals and fields all behave the same way.
- `select_cast_operator` (`src/backend/llvm.py`) chooses between `sext`
  and `zext` by the *target* (`signed = b.is_signed()`).  Whether the
  extension is signed depends on the *source*: only a signed source
  extends its sign.
- Constants are not affected: `Int32 Word8 0xff` and `Int32 k` for a
  `const k = Word8 0xff` are folded by the front end and give 255, which is
  why the existing tests, which convert mostly constants, never saw it.
- Only the LLVM backend.  C gives 255 / 65535.
- `tests/lang/value/cons/widen_unsigned.modest` reproduces it.


## BUG#85: LLVM backend converts `IntX` to `NatX` without `abs()`

```modest
var a: Int8 = -5
var b: Int32 = -5
let x = Nat32 a      // 251, expected 5
let y = Nat32 b      // 4294967291, expected 5
```

- `IntY → NatX` applies `abs()` (`docs/CHEATSHEET.md`, conversion table),
  and the C backend follows that: `(uint32_t)abs(i8)`, `llabs` for 64 bits.
  The LLVM backend emits nothing but the plain cast from
  `select_cast_operator` (`zext`, `trunc` or `bitcast`), so a negative value
  comes out as its two's complement bits.  Same width and widening are
  both affected.
- Constants are not affected: `Nat32 k` for a `const k = Int8 -5` is
  folded by the front end and gives 5.
- Not the same fault as BUG#84, though the code is next to it: fixing the
  choice of `sext`/`zext` there turns this case into `sext` and gives
  4294967291 for `Nat32 Int8 -5`.  The magnitude needs its own step before
  the cast (`llvm.abs.*` or `select` on `icmp slt`).
- `tests/lang/value/cons/int_to_nat.modest` reproduces it.


## BUG#86: LLVM backend zero-extends a negative literal constructed into `WordX`

```modest
var a: Word64 = -1          // llvm: 0xff      c11: 0xffffffffffffffff
var b: Word32 = -300        // llvm: 0xfed4    c11: 0xfffffed4
var c: Word64 = Word64 -1   // llvm: 0xff
var d: Word64 = -1 | 0x0F   // llvm: 0xff      (literal pair, see BUG#28)
var g: Word32 = -1          // at module level: the backend crashes
```

- A literal has no width of its own, so a negative one is the same value at
  any width, and as a `WordX` it has every bit above its magnitude set.
  The front end folds it that way — `const k: Word64 = -1` gives
  `0xffffffffffffffff` on both backends — and so does C.
- `do_eval_cons` (`src/backend/llvm.py`) sends `Integer → WordX` down the
  same path as `IntX → WordX`: `do_reval` of the literal, then `docast`.
  `do_reval` computes the negation at the literal's own width
  (`sub i8 0, 1`), and `select_cast_operator` picks the extension by the
  *target*, which is unsigned, so it is `zext`: the upper bits come back 0.
  The comment there (`int32(-1) -> uint64 => 0x00000000ffffffff`) is right
  for an `IntX` source, which has a width, and wrong for a literal.
- The same run-time `sub` is what crashes a module-level `var g: Word32 =
  -1`: `reg_get` asserts it is not in the global context.  A module-level
  `var h: Int32 = -1` is fine.
- The same fault as BUG#63 (a literal sized to its own value, then
  zero-extended), on the construction path instead of `~`.  An immediate
  operand should be emitted from its folded `asset` at the target's width.
- Only the LLVM backend.  No test covers it: `tests/lang/value/binary/
  literal_pair.modest` keeps its literal pairs non-negative because of it.


## BUG#87: C backend overflows `int` on a folded literal expression

```modest
const b = 0x7FFFFFFF + 1       // c11: -2147483648    llvm: 2147483648
var x: Int64 = 0x7FFFFFFF + 1  // c11: -2147483648
var w: Int64 = 0x40000000 * 2  // c11: -2147483648
```

- The front end folds `0x7FFFFFFF + 1` exactly, to 2147483648
  (`Integer(32)`), and the LLVM backend emits that value.  The C backend
  emits the expression as written instead: `#define B (0x7FFFFFFF + 1)`.
- Each operand gets its C suffix from its own value
  (`cvalue_literal_integer`, `src/backend/c11.py`): both fit an `int`, so
  neither gets one, and C adds them as `int` — signed overflow, undefined
  behaviour, and clang says so (`overflow in expression; result is
  -2'147'483'648 with type 'int'`).  Where it lands afterwards does not
  matter: `Int64` gets the wrapped value.
- `0xFFFFFFFF + 1` is correct only by luck: `0xFFFFFFFF` alone is wide
  enough to get the `UL` suffix, and the sum is done in `long`.
- Until 2026-09-30 `do_cvalue_bin_expr` cast the operands to the C type of
  the result when the result was wider.  That did not help here either:
  `Integer(32)` maps to the signed `int32_t`, which does not hold 2³¹.
- Fix: emit an immediate `Integer` expression from its folded `asset`, the
  way `do_cvalue_bin` already does for `Rational`/`FloatX` (keeping the
  source expression next to it as a comment), or give the operands the
  suffix the *result's* width needs.
- Only the C backend.  No test covers it.

## BUG#88: C backend's header uses a private type it does not declare

```modest
type Hidden = Int32

public type Opaque = record {
	h: Hidden            // private field: allowed in a public record
}
// c11: prog.h: unknown type name 'Hidden'
```

- A public record may keep a private type in a private field — the field
  is not part of the interface (`docs/lang/access_modifiers.md`), and the
  front end accepts it.  But C needs the complete struct wherever the
  type is used, so `do_header` (`src/backend/c11.py`) emits it into the
  header — while `Hidden`, being private (`is_private`), stays in the
  `.c`, and the header no longer compiles.
- Fix: emit into the header the private types the struct's private
  fields need (they stay private in Modest: an importer cannot name them,
  C does not care), or emit them in dependency order ahead of it.
- Only the C backend; LLVM has no headers.  Reproducer:
  `tests/lang/access_modifiers/private_in_public.modest`.

## BUG#90: C backend drops a construction on the right of an assignment

```modest
pragma unsafe

var buf: [4]Word32
var w: Word32
var n: Nat32

func main () -> Int {
	let p: Ptr = &buf
	var i: Int32 = -5
	let a = unsafe(Word32 p)   // ok: (uint32_t)p
	w = unsafe(Word32 p)       // c11: w = p;     — the cast is gone
	n = Nat32 i                // c11: n = i;     — the abs() is gone
	return 0
}
```

- In `do_cstmt_assign` (`src/backend/c11.py`), a non-literal construction
  into `IntX`/`NatX`/`WordX` whose operand is at most 32 bits wide is
  stripped, leaving C's implicit conversion to do the job.  The operand's
  kind is never checked, so the shortcut also fires where the construction
  is not a plain integer conversion:
  - **pointer → integer**: the `unsafe(WordX p)` / `unsafe(NatX p)` cast is
    lost and clang rejects the assignment
    (`incompatible pointer to integer conversion`).  Whether it fires
    depends on the target's pointer width: with a 32-bit pointer
    (`--config` with `pointer_width = 32`, e.g. RV32) `w = unsafe(Word32 &buf)`
    gives `w = buf;`, on a 64-bit target `*q = unsafe(Word64 &buf)` keeps
    the cast while `*q = unsafe(Word64 p)` (via a `Ptr` variable) loses it;
  - **`IntY → NatX`**: the construction applies `abs()`, the stripped
    assignment does not — `n = Nat32 i` with `i = -5` stores 4294967291
    instead of 5, with no diagnostic.  The same source in a `let` /
    `var` initializer is correct (`(uint32_t)abs(i)`).
- The LLVM backend handles the pointer case in both forms.  It gets
  `IntY → NatX` wrong in both forms too, but that is BUG#85, not this.
- Found in RV32-EMU (`sw/display`): `*reg(displayFB) = unsafe(Word32 &fb)`
  failed to compile.  Workaround: construct through `NatX` first —
  `Word32 unsafe(Nat32 &fb)` emits `(uint32_t)fb`; for `IntY → NatX`, bind
  the value with `let` first.
- Fix: strip only when the conversion is value-preserving in C — the operand
  is an `IntX`/`NatX`/`WordX` and not `IntY → NatX`; never for a pointer.
- No test covers it.

## BUG#91: `pragma insert` is accepted and does nothing

```modest
pragma insert "/* HELLO */"

func main () -> Int32 {
	return 0
}
```

- `c11` and `llvm` output contain no `/* HELLO */`, and there is no
  diagnostic.  The pragma becomes a `StmtDirectiveInsert`
  (`src/semantic.py`, `pragma` handling), but the C backend's call to
  `print_directive` in the module loop is commented out
  (`src/backend/c11.py`, `elif x.is_stmt_directive()`), and the LLVM
  backend has no handling for it at all.
- The node also stores the whole argument AST, not its text:
  `StmtDirectiveInsert(args[0], ...)` instead of `args[0]['str']`.  The
  `modest` backend, the only one that prints it, gives
  `pragma insert "{'isa': 'ast_value', 'kind': 'string', ...}"` — a
  round trip through `-mbackend=modest` breaks the source.
- Documented in `docs/lang/directive.md` as working.
- No test covers it.

## BUG#92: `@nonstatic` is rejected on a `func`, and the `modest` backend writes it there

```modest
func main () -> Int32 {
	return 0
}
```

`-mbackend=modest` re-emits this as

```modest
@nonstatic
func main () -> Int32 {
	return 0
}
```

and compiling that output fails with `annotation 'nonstatic' not defined`.

- `@nonstatic` is turned into an attribute only for a global `var`
  (`def_var_common`, `src/semantic.py`).  The definition loop that handles
  annotations common to all definitions maps only `extern`, `alias`, `c_no_print`,
  `used`, `unused` and reports everything else, so on a `func`, `const` or
  `type` it is an error.
- The compiler itself sets the attribute on `main` (`def_func2`), and the
  `modest` backend prints every attribute it finds — so its output for any
  program with `main` does not compile.
- Either accept `@nonstatic` on a `func` (the C backend already honours the
  attribute there) or keep the `modest` backend from printing an attribute
  the compiler added itself.
- No test covers it.

## BUG#93: A function type with an unnamed parameter is rejected by accident, with a generic message

```modest
type F = (Int32) -> Int
```

gives `expected type expr` at the `(`. The source is wrong (a function
type names its parameters, `(x: Int32) -> Int`), but it is rejected only
because of a bug in lookahead, and the message does not say what is wrong.

- The `(` branch of `check_is_type` (`src/parser.py:412-427`) first tries
  ` ( <type> ) `: `if self.is_type_expr(): return self.match(')')`.
  `is_type_expr` runs through `check()`, which restores the position, so
  `match(')')` is tried on `Int32` rather than after it and always fails.
  The parenthesized-type form therefore never matches at all, and
  `(Int32) -> Int` falls through to `check_is_field`, which wants
  `name:`.
- Fixing the lookahead alone does not help: with `check_is_type()` in
  place of `is_type_expr()` there (so the `)` is matched after the type)
  the error at the `(` stays, and two more appear on the next definition
  (`expected ':' token`, `expected type expr` at `func main () -> Int`).
- What is wanted is a dedicated diagnostic in `parse_type_func`: a type
  where a parameter is expected reports that the parameter has no name
  (`(x: Int32) -> Int`).
- `tests/lang/def/type/reject_malformed.modest` and
  `reject_no_cascade.modest` currently match the generic
  `expected type expr` for this case — update them with the fix.

## BUG#94: `NatX` of a negative `FloatY` applies `abs()` only when folded

```modest
const c: Float64 = -2.75
var f: Float64 = -2.75
let a = Nat8 c                // front end: 2    c11: 0    llvm: 2
let b = Nat8 f                // c11: 0    llvm: 0
```

- `IntY -> NatX` applies `abs()`, and `FixedY -> NatX` truncates and then
  applies it (`docs/lang/value/cons.md`). The front end folds a constant
  `FloatY` the same way: `value_nat_cons` (`src/value/nat.py`) takes
  `abs()` of the truncated value for every source.
- Neither backend does that at run time. The C backend prints the
  conversion as it is — `(uint8_t)f`, and `(uint8_t)NEG_HALF` for a
  `const`, since it prints the expression rather than the folded value —
  and LLVM emits `fptoui`. A negative float converted to an unsigned type
  is UB in C (6.3.1.4p1) and `poison` in LLVM; both give 0 in practice.
- So the same `Nat8 c` is 2 under LLVM and 0 under C11.
- Expected: `abs()` of the truncated value, as for the other signed
  sources — i.e. `fptosi` at the width of the source, then the same path
  as `IntY -> NatX`. If the language instead decides that a negative float
  does not fit `NatX` (QUESTION#6, UB#3), the fold has to stop applying
  `abs()` and `cons.md` has to say so.
- Coverage: `tests/lang/type/float/nat_negative.modest`, marked
  `EXPECTED-FAIL`.

## BUG#95: C backend passes an array return buffer of the other record name as it stands

```modest
type Point = {x: Int32, y: Int32}
type Vec2 = {x: Int32, y: Int32}

func makeVecs () -> [2]Vec2 { ... }

var ps: [2]Point = makeVecs()
```

```c
makeVecs(ps);
// error: incompatible pointer types passing 'struct point[2]' to
// parameter of type 'struct vec2 *'
```

- An array is returned through a buffer the caller passes in (`__out`).
  When the variable is an array of a structurally identical record type
  of another name, the backend hands the variable over as the
  buffer without converting the pointer, and the C compiler rejects the
  call.
- The LLVM backend is unaffected.
- Coverage: `tests/lang/type/record/structural_call_array.modest`, marked
  `EXPECTED-FAIL(c11)`.

## BUG#96: LLVM backend allocates a temporary slot anew on every loop iteration

```modest
var p: Point = {}
while i < 4000000 {
	p = makeVec(1, 1)        // makeVec () -> Vec2
	i = i + 1
}
```

```llvm
body_1:
	%6 = call %Vec2 @makeVec(%Int32 1, %Int32 1)
	%7 = alloca %Vec2          ; one more slot on every pass
	store %Vec2 %6, %Vec2* %7
```

- A temporary the backend makes for itself is written where its value is
  needed. An `alloca` outside the entry block is a dynamic one: it is
  released only when the function returns, so inside a loop the stack
  grows by one slot per iteration until the program crashes (exit -11 on
  4 million iterations).
- The slots of `var` and `let` no longer have this problem: they are
  collected before the body is printed and allocated in the entry block
  (`print_slots`, covered by `stack_local.modest`). That works because
  they are statements, known in advance; a temporary appears only while
  an expression is being evaluated.
- Four places emit such a temporary: a call result put under another
  record name (`cons_composite_from_composite`), a record or array value
  compared with `==` (the operands are spilled for `memcmp`), the return
  buffer of a function that returns an array (`do_eval_call`,
  `print_stmt_const`), and an array field of a record held in a register
  that is indexed at run time or sliced (`do_eval_index`,
  `do_eval_slice`).
- Recursion is not the issue: a frame's slots go away with the frame.
- Fix: emit the temporaries into the entry block too, as clang does.
  `out()` writes straight to the file and registers are numbered in
  order, so the body has to be buffered (`print_def_func`) and the
  hoisted `alloca`s given named registers that do not disturb the
  numbering.
- The C backend is unaffected: its temporaries are block-scoped C
  objects.
- Coverage: `tests/lang/stmt/while/stack_temporary.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#97: Named arguments and record literal fields are evaluated in declaration order

```modest
ascending(c = tick(), b = tick(), a = tick())   // a = 0, b = 1, c = 2
let r: Triple = {c = tick(), b = tick(), a = tick()}   // same
```

- [Evaluation order](lang/value/README.md#evaluation-order) is the
  order things are written: `c` should take the first `tick()`, so
  `c = 0, b = 1, a = 2`. Both backends give the opposite.
- The frontend sorts the parts into declaration order before anything is
  evaluated, and every backend then evaluates the sorted list: named
  arguments in the call lowering (`src/semantic.py`, the `process named
  args` loop walks the parameters and picks the matching argument for
  each), record fields in `value_record_cons` (`src/value/record.py`,
  walks `t.fields` and looks up the initializer by name).
- The C backend prints the record literal in the written order
  (`{.c = tick(), .b = tick(), .a = tick()}`), but C leaves the order of
  initializers unspecified, and clang happens to evaluate them in field
  order — so it fails the same way, see BUG#98.
- Fix: keep the written order as the evaluation order, and map each part
  to its parameter or field separately. When the two orders differ, a
  part with a side effect has to be evaluated into a temporary first.
- Coverage: `tests/lang/value/eval_order/written_order.modest`, marked
  `EXPECTED-FAIL(c11, llvm)`.

## BUG#98: C backend leaves evaluation order to the C compiler

```c
(void)ascending(tick(), tick(), tick());
(uint32_t [3]){tick(), tick(), tick()};
tick() - tick();
row[at(1, 2)] = value(2, 7);     // clang: value() runs first
```

- Modest evaluates left to right as written
  ([evaluation order](lang/value/README.md#evaluation-order)). The C
  backend emits arguments, literal elements, binary operands and both
  sides of an assignment as parts of one C expression, and C11 leaves
  their order unspecified (6.5p3, 6.5.2.2p10, 6.5.16p3, 6.7.9p23).
- Assignment already goes wrong: clang evaluates the right-hand side
  first, so `row[at(1)] = value(2)` runs `value` before `at`, and
  `rowPointer(1)[at(2)] = value(3)` traces 3, 1, 2. The rest happens to
  come out left to right under clang on the targets tried — another C
  compiler, or another clang version, may legally pick a different
  order. The LLVM backend emits each part as its own instruction and
  gets these right.
- Fix: when two or more parts of one expression or assignment can have a
  side effect (a call, an assignment), evaluate them into
  temporaries in order first. Expressions without side effects stay as
  they are, so the common `f(x, y + 1)` and `a[i] = x` keep their plain C.
- Coverage: `tests/lang/value/eval_order/assign.modest` and
  `assign_index.modest`, marked `EXPECTED-FAIL(c11)`;
  `basic.modest`, `binary.modest` and `index.modest` pass under clang,
  and are what catches a compiler that disagrees.

## BUG#100: The bounds of a run-time slice are evaluated more than once, or not at all

```modest
s = rowValue(1)[at(2, 1):at(3, 3)]            // c11: 1 2     llvm: 1 2 3 2
row[at(1, 2):at(2, 4)] = [2]Int32 [v3, v4]    // c11: 1 3 4 2 1   llvm: 1 3 4
```

- Each part of `a[i:j]` should run exactly once, `a`, `i`, `j` in that
  order ([evaluation order](lang/value/README.md#evaluation-order)). With
  a bound known only at run time, the slice's length `j - i` is computed
  from the bound *expressions* wherever a length is needed, not from
  their values, so a bound with a side effect runs as many times as the
  length is used — and not at all when the length comes from elsewhere:
  - c11, read: `memcpy(&s, &rowValue(1)[at(2, 1)], sizeof(int32_t [2]))`
    — the length is taken from `s`, so `at(3, 3)` never runs.
  - c11, target: `memcpy(&row[at(1, 2)], ..., sizeof(int32_t) * (at(2, 4)
    - at(1, 2)))` — `at(1, 2)` runs twice, after the value.
  - llvm, read: the lower bound runs once for the address and again for
    the length.
  - llvm, target: the length is taken from the value, so the upper bound
    never runs.
- Worse than an ordering problem: a counter, a read from a device
  register or an allocation in a bound happens the wrong number of times
  on both backends.
- Fix: evaluate each bound once into a temporary and compute the length
  from those.
- Coverage: `tests/lang/value/eval_order/slice.modest`, marked
  `EXPECTED-FAIL(c11, llvm)`.

## BUG#102: `Unit` is accepted as a storage type again (regression of BUG#58)

```modest
type Holder = {u: Unit}           // accepted, should be "unsuitable type"
var globalUnit: Unit              // accepted; in C: `void globalUnit;`
func take (u: Unit) -> Unit {}    // accepted
```

- `Unit` has no storage, so a field, parameter, variable, constant or
  array element of it must be rejected with `unsuitable type`; it is
  fine only as a result type and behind a pointer (`*Unit`).
- The `is_unit()` checks in `Type.is_forbidden_any` /
  `Type.is_forbidden_field` (`src/hlir/types.py`) are commented out
  (fcec4bb9, 2026-10-12), so every such definition compiles silently.
  They were disabled on purpose; what they broke still has to be sorted
  out before they come back.
- Coverage: `tests/lang/type/unit/reject_storage.modest`, marked
  `EXPECTED-FAIL`.

## BUG#104: Bodies of functions in an included module are not emitted

```modest
// bind.modest — pragma do_not_include, pragma prefix ""
public func twice (x: Int32) -> Int32 { return x * 2 }

// main.modest
include "./bind"
twice(21)      // C: undeclared function 'twice'; LLVM: undefined symbol _twice
```

- An `include`d module is never printed by the C backend (`do_cfile`
  marks its definitions as already defined, and a `do_not_include`
  module has no header), and the LLVM backend prints its functions with
  `print_decl_func` only (`print_included`, `src/backend/llvm.py`).  A
  body there is compiled by the front end and then dropped.
- Library bindings get away with it while C has the same name: a
  function-like macro under `@alias("...", backend="c11")` — `sIsdir`/`S_ISDIR` and
  the rest in `lib/libc/stat.modest` — or a libc function that also
  exists as a symbol (`htons` in `lib/libc/arpa/inet.modest`, which LLVM
  then links against libc instead of the body).  The macro case does not
  link in LLVM: `include "libc/stat"` + `sIsdir(m)` gives `undefined
  symbol _sIsdir`.  So the `@alias("...", backend="c11")` + body idiom for macros
  works in the C backend only.
- A function with no C twin (`assert` in `lib/std.modest`, any helper
  written in Modest) does not link in either backend.
- Coverage: `tests/lang/import/include_func_body.modest`, marked
  `EXPECTED-FAIL`.

## BUG#106: A binding type with no C alias has no name in the C backend

```modest
include "libc/stat"    // public type DevT = Nat32 — no @alias
let d: DevT = st.st_dev    // c11: unknown type name 'DevT'
```

- An `include`d module is never printed by the C backend, so its types
  reach C only by their `@alias("...", backend="c11")` name.  A type with
  no alias (`DevT`, `NLinkT`, ... in `lib/libc/stat.modest`; `ModeT`
  has one) is printed by its Modest name, which nothing defines.  The LLVM backend is
  not affected.
- Works as long as the program never names the type: `st.st_mode &
  sIfmt == sIfdir` compiles, `let d: DevT = st.st_dev` does not.
- Either give every binding type its C name or print the alias-less
  ones as `typedef`s.

## BUG#107: `libc/errno` does not link on macOS

```modest
import "libc/errno"
errno.get()    // Undefined symbols: ___errno_location
```

- `lib/libc/errno_abi.modest` binds `__errno_location`, which is glibc's
  name; Darwin's libc has `__error` instead.  Both backends fail to link.
- `lib/libc/stat.modest` is Darwin-only already (its `struct stat`
  layout), so the library has no single target it works on as a whole.
- `lib/fs.modest` binds `__error` itself until this is fixed.

## BUG#116: An array literal with a VLA value as a row is miscompiled

```modest
var n: Nat32 = 2
var r: [n]Int32 = [5, 6]
var a: [2][n]Int32 = [r, r]
```

- C emits a compound literal of the VLA type, `(int32_t [2][__a_1]){r, r}`:
  `compound literal cannot be of variable-length array type`.
- LLVM compiles it and the program prints garbage.
- A literal whose rows are literals works (BUG#112, BUG#115): the backend
  builds it at its own length and copies it row by row (`vla_literal_type`
  in `src/hlir/types.py`).  A row that is a VLA value is not a literal, so
  it falls back to the old path; it needs a VLA copy of its own, by the
  rules of QUESTION#7.

## BUG#117: LLVM drops the sign of `-0.0` inside a local record or array literal

```modest
var p: Point = {x = -0.0, y = 1.0}
var a: [2]Float64 = [-0.0, 1.0]
1.0 / p.x     // c11: -inf    llvm: inf
1.0 / a[0]    // c11: -inf    llvm: inf
```

- A local literal is built from `zeroinitializer` with `insertvalue` for
  each item, and an item that is zero is skipped as already there
  (`do_eval_record`, `src/backend/llvm.py:2453`; `do_eval_array_local`,
  `:2421`).  `Value.is_zero()` (`src/hlir/types.py`) compares the asset
  with `0`, and `-0.0 == 0` in Python, so `-0.0` counts as zero and the
  field is left `+0.0`.
- Only the local path loses it: a scalar `var s: Float64 = -0.0`, and a
  global record or array literal, keep the sign.  The C backend is
  unaffected — it prints the literal as written.
- Visible wherever the sign of zero matters: division (`1.0 / x`),
  `copysign`, and the bits a `Word64` construction reinterprets.  Record
  and array `==` are not affected — they compare floats as floats, and
  `-0.0 == 0.0` (BUG#26).
- Fix, probably: an `is_zero()` that a floating `-0.0` fails — compare
  the bits, or check the sign — or skip only values that are zero in
  every bit.  `is_negated_zero` in the same file already recovers the
  sign for a constructed value.
- Coverage: `tests/lang/type/float/negative_zero_aggregate.modest`,
  marked `EXPECTED-FAIL(llvm)`.  `tests/lang/value/binary/aggregate_fieldwise.modest`
  builds its `-0.0` at run time (`-zero`) to stay clear of this.

## BUG#118: LLVM rejects a global union literal through any but its most aligned field

```modest
type Slot = @layout("union") {
	word: Word32
	bytes: [4]Word8
}

var a: Slot = {word = 0xFFFFFFFF}             // fine
var b: Slot = {bytes = [0x11, 0x11, 0x11, 0x11]}
// llvm: error: a global union initialised through a field other than its
//       most aligned one is not supported yet
```

- LLVM has no union type: a union record is emitted as its most aligned
  field, padded with bytes up to the union's size (`str_type_union` in
  `src/backend/llvm.py`).  A constant of that type can only spell out that
  one field, so `do_eval_union` refuses a global literal that names another.
  A local literal is not affected — it writes the field through memory.
- The usual fix, and what clang does for C: give such a global the type of
  its own initializer — `{ [4 x i8], <padding> }` — instead of `%Slot`.
  With opaque pointers every use of the global still works.  The hard part
  is nesting: a union inside a global record (or array) makes the enclosing
  constant need its own literal type too, all the way up.
- The C backend is unaffected — it prints a designated initializer.
- Coverage: `tests/lang/type/record/union_global.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#119: A constant narrower than `Float64` is rounded twice

```modest
const lit: Float32 = 16777217.000000001   // 2^24 + 1 + 1e-9
// expected 16777218.0, c11 and llvm both give 16777216.0

const big: Int64 = 4611686293305294849    // 2^62 + 2^38 + 1
const f = Float32 big
// expected 4611686568183201792.0, llvm gives 4611686018427387904.0
```

- Cause: `pack_float` (`src/real.py`) rounds an exact `Fraction` or `int`
  to the target width as `struct.pack('<f', float(val))` — first to the
  nearest double, then to the nearest binary32. The first rounding can land
  exactly on a binary32 halfway point, and the second one then breaks the
  tie to even instead of up: the same double-rounding error as
  `(float)(double)x` in C. Both values above sit just over such a halfway
  point by less than a double can hold.
- Everything that folds a constant into a `Float32` or `Float16` goes
  through it: both backends print the literal from `pack_float`
  (`src/backend/c11.py:498`, `src/backend/llvm.py:617`), so a `Rational`
  literal is wrong in both. An integer constant constructed to `Float32`
  is wrong only under LLVM — the C backend prints the conversion,
  `((float)BIG)`, and lets the C compiler round it once.
- Run-time conversions are not affected: `sitofp`/`(float)i` round once.
- Fix, probably: round the exact value to the target's significand width
  directly (scale the `Fraction` by a power of two, round half to even,
  check the exponent range), and only then pack it.  The C backend has to
  print it with an `f` suffix or as a hex float, or the C compiler reads
  the decimal as a double and rounds it a second time on its own.
- Coverage: `tests/lang/type/float/fold_rounding.modest`, marked
  `EXPECTED-FAIL(c11, llvm)`.

## BUG#120: A NaN or an infinity constant constructed to an integer crashes the compiler

```modest
const n = Int32 builtin.nan    // ValueError: cannot convert float NaN to integer
const i = Int32 builtin.inf    // OverflowError: cannot convert float infinity to integer
const u = unsafe(Nat32 builtin.nan)    // same traceback
```

- Cause: the compile-time fold of `FloatY → IntX/NatX` calls `int()` on
  the asset (`frac_to_int`, `src/value/int.py:22`), which Python refuses
  for a `float` NaN or infinity. A finite value out of range is caught
  before that and reported as `integer overflow`.
- Not new with `builtin.nan`/`builtin.inf`: a NaN built from its bits,
  `unsafe(Float64 Word64 0x7FF8000000000000)`, crashes the same way.
- Expected: without `unsafe`, `integer overflow` with the same
  `attempt to construct` note as for `Int8 300.0` — neither value fits
  any integer. With `unsafe`, whatever `unsafe(Int8 300.0)` does, never
  a traceback.
- Coverage: `tests/lang/value/cons/reject_special_to_int.modest`, marked
  `EXPECTED-FAIL`.
