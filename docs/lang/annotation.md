# Annotations

An *annotation* is the source form that attaches *attributes* to a
definition or a type expression and influences translation. The attribute
is a property of the entity itself; the annotation is how it is written.

## Form

```
@<#name#>
@<#name#>(<#arguments#>)
```

Annotations are written before a definition, or inside a type expression
(qualifying the type to the right of them).

## Reference

### Inlining

| | |
| :-- | :-- |
| `@inline` | request inlining |
| `@inlinehint` | weak inlining hint |
| `@noinline` | forbid inlining |

### Linkage & C interop

| | |
| :-- | :-- |
| `@extern` | declaration: the symbol is defined outside the module |
| `@extern("name")` | declaration of the symbol `name` |
| `@extern("name", backend="c11"\|"llvm")` | symbol name for one backend |
| `@alias("name")` | definition emitted under another name (all backends) |
| `@alias("name", backend="c11"\|"llvm")` | output name for one backend |
| `@c_no_print` | keep the definition out of C output: the C side already has it (a header) |
| `@cbyvalue` | on a `const`: print its literal value at each use site instead of the identifier (C backend only) |
| `@nonstatic` | on a global `var`: suppress `static` in C output (rejected on a `func` — BUG#92) |

> **`@extern` declares, `@alias` renames a definition.** Whether there is a
> body decides which one fits: the block of a `func`, the initializer of a
> `var` or `const`, the right side of a `type`. `@extern` is for a symbol
> defined outside the module — no body, nothing is emitted for it, and the
> module prefix never applies. `@alias` is for a symbol defined here — it
> needs the body and only changes the name in the output. The wrong one is
> an error (`@extern on a definition`, `@alias on a declaration`,
> `initializer in extern variable definition`), and so are both together.
>
> The first argument is the name; anything after it must be named
> (`backend="c11"` or `backend="llvm"`, the `-mbackend` names). Without
> `backend` the name holds for every backend. Each annotation sets one
> name, so different names per backend take several:
> `@alias("x", backend="c11") @alias("y", backend="llvm")`; two for the
> same backend are an error.
>
> On a record field `@alias` names the field in the output, by the same
> rules — a C struct can be bound under Modest names:
> `@alias("tm_mday") day: Int`. LLVM has no field names, so there it
> changes nothing.
>
> A C macro or typedef the compiler must know the value or layout of
> (`INT8_MIN`, `ino_t`, `struct dirent`) is a definition on the Modest
> side: write it out and name it with `@alias("...", backend="c11")`. In
> an `include`d module it is never printed; in the module being compiled add
> `@c_no_print` so that it does not clash with the header. A function
> body under `@c_no_print` still serves the LLVM backend, which has no
> headers — that is how a C function-like macro (`S_ISDIR`) gets bound.
>
> `@extern` belongs to a global definition only — on a local `var` it is an
> error (`extern is allowed only for global definitions`).

### Diagnostics & lifetime

| | |
| :-- | :-- |
| `@used` | keep symbol even if unreferenced |
| `@unused` | suppress unused warnings (also on return types: `-> @unused Int`) |

### Mutability

| | |
| :-- | :-- |
| `@immutable` | `var` cannot be reassigned after initialization |

### Type layout & memory

| | |
| :-- | :-- |
| `@layout("packed"\|"union"\|"exact")` | record layout |
| `@alignment(N)` | alignment in bytes |
| `@volatile` | volatile qualifier |
| `@restrict` | restrict qualifier |
| `@section("name")` | linker section |
| `@branded` | nominal type (see [branded](./type/branded.md)) |
| `@fraction(N)` | in a type, before `FixedX` (`x: @fraction(16) Fixed32`): N fractional bits, the binary point (applied by the fold and at run time alike; remaining limitations in BUG#25) |

### Access

| | |
| :-- | :-- |
| `@public` | on a record type: default-access fields become public |

### Not implemented

These names appear in the compiler's internals or in older docs, but the
compiler rejects them in source with `annotation '...' not defined`:

| | |
| :-- | :-- |
| `@deprecated` | planned: warn at use sites (see `docs/todo/TODO.md`) |
| `@const` | const qualifier |
| `@zarray` | zero-terminated array (see `docs/todo/TODO.md`) |
| `@no_print`, `@ll_no_print` | omit the definition from output; for C there is `@c_no_print`, for a whole module `pragma c_no_print` |

## Examples

```modest
@inline
func min (a: Int32, b: Int32) -> Int32 {
	if a < b { return a }
	return b
}

@extern("malloc")
func myAlloc (size: Nat64) -> Ptr

@alias("INT8_MIN", backend="c11")
const int8MinValue: Int8 = -128   // a C macro: the value is known here too

@used @section("__DATA,.table")
var table: [256]Word8 = []

@extern
var environ: []Ptr   // an extern global may leave the array unsized

type Packet = @layout("packed") {
	tag: Word8
	len: Nat32
}

var uartByte: @volatile Word8

@immutable var maxItems: Int32 = 100
maxItems = 200  // error: expected mutable value
```

## See also

- [Pragmas](./directive.md) — module-level directives
- [Type definitions](./def/type.md)
