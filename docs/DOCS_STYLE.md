# Docs Style Guide

How to write pages under `docs/`. Modest code inside them follows
[STYLE.md](STYLE.md).


## Page structure

Where it applies, a page describes one construct in this order:

1. **Form** — the syntax.
2. **Semantics** — what it means and how it behaves.
3. **Examples**.


## Notes

Side remarks — clarifications, limitations, edge cases — go in a quote
**after the example** they refine: paragraph → example → notes. The core
rule stays in the paragraph; a note that has nothing to do with the
example belongs in the paragraph itself.

One note is a single quoted line; several are a list. The list needs an
empty `>` line before it:

```markdown
> Notes:
>
> - one
> - two
```

Without that line MkDocs (Python-Markdown) does not see a list and glues
the items into one paragraph — GitHub and editor previews still show a
list, so the error goes unnoticed. Nested items need a 4-space indent.


## Warnings

`⚠️` marks only what is both dangerous and non-obvious — typically code
that compiles but silently does something other than expected. Anything
the compiler reports by itself needs no mark; ordinary caveats are notes.
Used rarely, the mark keeps catching the eye.

```markdown
⚠️ `Rational` is an exact fraction, not a float: `0.1 + 0.2 == 0.3` is true.
```
