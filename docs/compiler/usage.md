# Usage

`modest` is a thin bash wrapper: it activates the venv and runs
`src/main.py`.

## Invocation

```sh
export MODEST_DIR=/path/to/Modest      # compiler root
export MODEST_LIB=$MODEST_DIR/lib      # library search path

modest -o <out> [options] <files.modest>
```

| Option | Meaning |
| :-- | :-- |
| `-o <path>` | output base name (`<path>.c`, `<path>.h`, `<path>.ll`, ...) |
| `-mbackend=c11\|llvm\|modest` | backend selection (any `-m<key>=<value>` overrides a config key) |
| `--config=<file.toml>` | target config, applied over `cfg/default.toml` |
| `--metrics` | print a report about each source (see below) |
| `--metrics-format=yaml\|json` | format of that report (default `yaml`; implies `--metrics`) |
| `-f <feature>` | enable a feature (`unsafe`, `paranoid`) |
| `-L <path>` | library path (overrides `MODEST_LIB`) |
| `-i <dir>` | directory for emitted `#include` paths |

Configuration is layered: `cfg/default.toml` → `--config` file → `-m`
overrides. The config defines the target (arch, OS, ABI, endianness),
type widths (`int_width`, `pointer_width`, ...) and the backend.

The compiler emits source; producing a binary is the build system's
job — each project's `Makefile` runs `modest`, then `cc`/`clang` on the
output (see `examples/*/Makefile` for the pattern).

## Metrics

`--metrics` prints one document per input file to stdout, before the
backend runs. It is a report about the source, not about the compiler's own
work — the counts come from the HLIR, so they say what a grep over the text
cannot. (Every other compiler spells this `-fstats` / `-print-stats` /
`-Zhir-stats` and means the opposite by it: how much work the compiler
itself did. Hence `metrics`, and hence an option rather than a `-f`
feature — it changes nothing about the compilation, it only reports.)

```sh
modest --metrics -mbackend=none -o /dev/null main.modest
```

```yaml
---
module: main
source: examples/0/src/main.modest
lines:
  total: 27
  blank: 11
  comment: 1
  code: 15
imports:
  total: 2
  modules: 0
  includes: 2
  unused: 0
definitions:
  types: {total, public, by_kind: {record, variant, array, pointer, func, alias}}
  functions: {total, public, prototypes, pure, variadic, params_max}
  variables: {total, public, bytes}
  constants: {total, public, bytes}
statements:     # every HLIR statement node, by kind
values:         # every HLIR value node, by kind
memory:         # static storage and the heaviest stack frame
complexity:     # deepest nesting and highest cyclomatic complexity
functions:      # the same per function, one entry each
```

`values.cons_by_method` splits value construction by how it was reached
(`implicit`, `explicit`, `unsafe`, `default`, `extra_arg`) — Modest has no
casts, so this is where conversions show up.

### Machine-readable output

`--metrics-format=json` prints the same report as JSON, and turns the
report on by itself — asking for the format of something that is not
printed is not a thing anyone means. Each file still gets its own
document, so several files give several JSON objects back to back; `jq`
reads such a stream as it is, and `jq -s` collects it into an array:

```sh
modest --metrics-format=json -mbackend=none -o /dev/null src/*.modest |
	jq -s 'map({module, code: .lines.code, frame: .memory.frame_max_bytes})'
```

The format is a closed set (`yaml`, `json`), so a typo is refused at the
command line rather than silently ignored.

Two things the report cannot know:

- **`imports.unused` covers `import` only.** `usecnt` is tracked for modules
  registered in `module.imports`; an `include` is not one of them, so its
  use is invisible and it is never reported as unused. The same counter does
  not exist for functions, variables and constants at all.
- **`lines` is counted over the text, not the HLIR.** The parser keeps only
  the comment that sits directly before a statement, so counting comment
  lines from the AST would under-report them.

## Testing

```sh
cd tests && ./run.py        # the whole suite
./run.py -b c11             # one backend
./run.py prog               # one part of the tree
```

One `.modest` file per test, expectations in its leading comment block:
`lang/` per language feature, `prog/` whole programs — the latter includes
the known-answer tests for `sha256`, `aes256`, `chacha20`, `crc32` and
`xxh64`. Known compiler bugs
are tracked in [../BUGS.md](../BUGS.md), design plans in
[../todo/TODO.md](../todo/TODO.md).
