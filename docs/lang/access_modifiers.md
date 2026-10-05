# Access Modifiers

`public` and `private` control whether a definition is visible to
importing modules.

## Form

```
public <#definition#>
private <#definition#>
<#definition#>            // default
```

## Semantics

A definition without a modifier gets the internal *default* access,
resolved by context:

- module-level definitions: default → `private`;
- named record fields: default → `private`
  (→ `public` if the record type has the `@public` annotation);
- anonymous record fields: default → `public`.

Enforcement is **per module**: `private` restricts importers only;
inside the defining module everything is accessible.

### A public interface may not expose private types

A `public` definition may not mention a private type in its *interface* —
the part an importer sees.  An importer could use the definition but not
name the type it is built from.  The interface is:

| Definition | Interface |
|---|---|
| `public const` / `public var` | its type (explicit, or the type of the constructed value: `public const c = Hidden 0`) |
| `public type T = ...` | the right-hand side |
| `public func` | parameter types and the return type |

A private type is found through any nesting: pointers, arrays, function
types, variants, and every **non-private** field of a record — an
explicit `public` field, a field of an `@public` record, and any field of
an anonymous record (public by default).  The error is reported once per
definition and points at the first offending use of the private type — in
a record, at the field to fix; the message names both:

```
error: public type `R` exposes private type `Hidden`
5 |    public c: Hidden
                  ^
```

Not part of the interface, and so allowed:

- private fields of a public record (by default or explicitly `private`,
  also inside an `@public` record) — this is how an opaque type is made;
- the body of a public func;
- anything in a private definition.

```modest
type Hidden = Int32

public type Alias = Hidden              // error
public type Arr = [4]Hidden             // error
public func f (p: {x: Hidden}) -> Unit  // error: anonymous field is public
public func g () -> *Hidden             // error

public type Opaque = record {
	h: Hidden                           // ok: private field
}
public func make (v: Int32) -> Opaque { // ok: Hidden only in the body
	var h: Hidden = v
	return {h = h}
}
```

Tests: `tests/lang/access_modifiers/private_in_public*.modest`.

Consequences in output: `public` symbols of module `m` are emitted with
the prefix `m_`; `private` symbols keep their name (and become `static`
in C). `@extern` suppresses the prefix entirely
(see [import](./import.md), [annotations](./attribute.md)).

## Examples

```modest
public func api () -> Unit { ... }     // visible to importers, emits m_api
func helper () -> Unit { ... }         // private by default

public type Point = @public {          // type and its fields public
	x: Float64
	y: Float64
}

type Conn = {
	fd: Int                            // private field: hidden from importers
	public state: Nat8                 // explicitly public field
}
```

## See also

- [Definitions](./def/README.md), [Record type](./type/record.md)
