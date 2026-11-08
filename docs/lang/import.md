# Import & Include

Bring another module's public definitions into the current module —
under a namespace (`import`) or directly (`include`).

## Form

```
import <#"path"#> [as <#identifier#>]
include <#"path"#>
```

## Semantics

- `import "m"` — public definitions of `m` are accessed as `m.name`;
  `as x` renames the namespace to `x`.
- `include "m"` — public definitions enter the current namespace and
  are used unqualified. Idiomatic for C bindings (`libc/*`).
- Path resolution (`.modest` appended automatically; a legacy `.m` file
  is tried next, so unrenamed modules still resolve):
  1. paths starting with `./` or `../` — relative to the importing file;
  2. otherwise, the importing file's directory;
  3. otherwise, the library directory (`MODEST_LIB` / `-L`).
- A module is translated once; repeated imports reuse it. Recursive
  imports are an error (`recursive import detected`).
- In output, public symbols and all types of an imported module get its
  name as a prefix (`utils_f`); `include`d modules keep original names
  (see [access modifiers](./access_modifiers.md)).

## Module name

```modest
module "geo/point"
```

An optional first line of the file names the module.  The name is one or
more identifiers separated by `/`, and its last part is the file name
without the extension: `module "geo/point"` belongs in `point.modest`, and
in any other file it is an error.  With `/` turned into `_` the name becomes
the prefix of the module's public symbols: `make` is `geo_point_make` in
C and LLVM.  Without it the prefix is the source basename (`point_make`).

The name is written in the module itself, so every compilation that meets
the module — its own and each importer's — gives its symbols the same
names.  That is what lets two modules with the same file name, such as
`geo/point.modest` and `ui/point.modest`, be linked into one program.

- It does not change how the module is imported: importers still use its
  path, and `import "geo/point"` still names the namespace `point`.
- It does not change file names: the C header, its include guard and the
  output files still follow `-o`.
- `pragma prefix "p"` later in the file overrides the prefix it sets.

## Examples

```modest
include "libc/stdio"          // printf, unqualified
import "misc/sha256"          // namespace sha256
import "./engine" as eng      // relative path, renamed

func main () -> Int {
	var h: sha256.Hash
	sha256.hash(data, len, &h)
	eng.start()
	printf("done\n")
	return 0
}
```

## See also

- [Pragmas](./directive.md) — `pragma prefix`, `pragma do_not_include`
- [Access modifiers](./access_modifiers.md)
