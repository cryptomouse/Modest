# Built-in Constants

Every module implicitly imports the `builtin` namespace with information
about the compiler and the target platform.

`builtin.compiler` and `builtin.target` are record constants, not nested
modules: every field is known at compile time and folds to its literal.
Types cannot be record fields, so the target-width types live directly in
`builtin` (`builtin.Word`, not `builtin.target.Word`).

## Top-level constants

A few constants are bound directly at module scope, not under the
`builtin.` namespace:

```modest
true, false          // Bool
nil                  // untyped null pointer
```

## Reference

```modest
// compiler
builtin.compiler.name                 // string
builtin.compiler.version.major        // Nat32
builtin.compiler.version.minor        // Nat32
builtin.compiler.version.patch        // Nat32

// target: widths in bits (cfg/*.toml)
builtin.target.wordWidth              // word_width
builtin.target.pointerWidth
builtin.target.charWidth
builtin.target.intWidth
builtin.target.floatWidth
builtin.target.rationalPrecision      // decimal digits — see below

// target: identity (branded string constants for comparison)
builtin.target.name
builtin.target.arch       // compare with: archX86, archX86_64, archArm,
                          //   archAarch64, archRiscv32, archRiscv64
builtin.target.os         // osLinux, osMacos, ...
builtin.target.abi        // abiSysV, abiEabi, ...
builtin.target.endian     // endianLittle, endianBig

// target-width type aliases (word_width, integer_width)
builtin.Word, builtin.Int, builtin.Nat

// IEEE 754 specials: generic Float
builtin.nan                           // quiet NaN
builtin.inf                           // +infinity; -builtin.inf for -infinity
```

Everything under `builtin.target` comes from the target settings in
`cfg/*.toml` (any of them can be overridden with `-m<key>=<value>`):

| field | setting | values |
|-------|---------|--------|
| `name` | `target_name` | any string |
| `arch` | `arch` | `x86`, `x86_64`, `arm`, `aarch64`, `riscv32`, `riscv64` |
| `os` | `os` | `linux`, `windows`, `macos`, `noos` |
| `abi` | `abi` | `sysv`, `win32`, `win64`, `eabi`, `unknown` |
| `endian` | `endianness` | `little`, `big` |

A value outside the list is a fatal error. These settings describe the
target to the program; they do not change what the backends generate
(that is `[backend.*]`, e.g. the LLVM `target_triple`).

The unqualified aliases `Int`, `Nat`, `Word`, `Size` are also available
directly (see [base types](./type/base.md)).

`builtin.target.rationalPrecision` (`Integer`, 256 by default) mirrors
`precision` in `cfg/*.toml`: the number of significant decimal digits
the **C backend** writes out when it renders a `Rational`/`Float`
constant literal as text. It does not affect `Rational` arithmetic
itself (already exact via an arbitrary-precision fraction), and it has
no effect on the LLVM backend, which always rounds such literals to
`Float64`. Nor does it carry through a compound expression (`3.14 +
0.5`) — see
[Rational precision](./type/generic.md#rational-precision) for the full
picture and caveats.

## NaN and infinity

`builtin.nan` and `builtin.inf` are the IEEE 754 values that have no
literal. A `Rational` constant is an exact fraction and cannot hold
either, so both are *generic Float* constants: like an untyped numeric
literal they take the type of their context and convert implicitly to
any `FloatX` (`Float16`, `Float32`, `Float64`). Without a context
(`let x = builtin.inf`) they are `Float` (`float_width`).

```modest
var d: Float64 = builtin.nan
var h: Float16 = -builtin.inf
```

NaN is unordered: it is unequal to every value, itself included, so
`x != x` is the way to detect it. `==`, `<`, `>`, `<=`, `>=` with a NaN
operand are `false`, `!=` is `true` — the same at run time and when the
comparison is folded at compile time.

## Example

```modest
if builtin.target.endian == builtin.target.endianLittle {
	printf("little-endian\n")
}

var w: builtin.Word                   // target word width

printf("rational precision: %d digits\n", Int32 builtin.target.rationalPrecision)
```
