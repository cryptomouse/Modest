# Pragmas

A *pragma* is a module-level directive: it configures translation of the
current module. Pragmas take effect from their position to the end of
the file.

## Syntax

```
pragma <#name#> [<#arguments#>]
```

## Reference

| Pragma | Effect |
| :-- | :-- |
| `pragma unsafe` | allow `unsafe` constructions in this module |
| `pragma prefix "p"` | output-symbol prefix for this module (empty string disables) |
| `pragma c_include "h.h"` | emit `#include "h.h"` in C output |
| `pragma do_not_include` | importers do not `#include` this module's header |
| `pragma c_no_print` | omit this module's definitions from C output |

## Examples

```modest
// C binding module: no prefix, no own output
pragma prefix ""
pragma do_not_include

@extern
public func write (fd: Int, buf: Ptr, n: Size) -> Size
```

```modest
pragma unsafe
pragma c_include "./sha256.h"

let bytes = unsafe(*[]Word8 data)
```

## See also

- [Annotations](./annotation.md) — per-definition metadata
- [Module name](./import.md#module-name) — `module "geo/point"`, which
  also sets the symbol prefix
- [Import](./import.md)
