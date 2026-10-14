# Type Definition

Binds an [identifier](../identifier.md) to a [type](../type/README.md).

## Form

```
type <#identifier#> = <#type_expression#>
@extern type <#identifier#>
```

## Semantics

- The type system is *structural*: a defined name is an alias, fully
  compatible with its right-hand side and with any structurally equal type.
  To obtain a nominal (incompatible) type, add
  [`@branded`](../type/generic.md):

  ```modest
  type Meters = @branded Float64   // not mixable with plain Float64
  ```

- Recursive types need no forward declaration — all module-level type names
  are visible before definitions are processed:

  ```modest
  type Node = {
  	next: *Node
  	data: Ptr
  }
  ```

- Type definitions are allowed inside function bodies; the name is then
  local to the body.
- Layout and qualifiers are controlled with annotations on the right-hand
  side: `@layout("packed" | "union" | "exact")`, `@alignment(N)`,
  `@volatile`, `@const` (see [annotations](../annotation.md)).

## Extern types

A `type` with no right side is a declaration of a type defined outside the
module — an opaque C type such as `FILE` or `SDL_Window`. It needs
[`@extern`](../annotation.md); the optional name is the C typedef
(`@extern("FILE")`), without it the Modest name is used as is.

```modest
@extern("SDL_Window")
public type Window

@extern("SDL_CreateWindow")
func createWindow: (title: *Str8, w: Int32, h: Int32, flags: Word32) -> *Window
```

- Only the name is known — no size, no fields — so the type is used behind
  a pointer: `*Window`. A value of it (a `var`, `const`, field, parameter,
  return value), an array of it, a dereference, `sizeof` and `alignof` are
  errors.
- An extern type is nominal: two of them are different types even under the
  same C name; convert between their pointers through `Ptr`. An alias
  (`type Handle = Window`) is the same type.
- The name must be a typedef, not a `struct tag`. Nothing is printed for it
  in C output (the header has it); LLVM output declares `%Name = type opaque`.
- Only at the top level: a type declared inside a function body is an error.

## Examples

```modest
type MyInt = Int32
type CStr = *Char8
type Buffer = [256]Word8

type Point = {x: Int64, y: Int64}

type Color = @layout("union") {
	code: Word32
	rgba: {r: Nat8, g: Nat8, b: Nat8, a: Nat8}
}
```
