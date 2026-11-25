# Docs Style Guide

How to write pages under `docs/`. Modest code inside them follows
[STYLE.md](STYLE.md).


## Page structure

Where it applies, a page describes one construct in this order:

1. **Syntax** — how it is written.
2. **Semantics** — what it means and how it behaves.
3. **Examples** — working code.

When Syntax shows concrete records besides the template, it splits in
two subsections:

- **Form** (`### Form`) — the template with `<#placeholders#>`, plus the
  rules of writing it;
- **Instances** (`### Instances`) — concrete records of that form, not
  programs: `[10]Int32`, `*[]Char8`.

A Syntax made of the template alone stays without subsections. The
names keep away from *Examples*: one page, one `#examples` anchor.


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

The same 4 spaces hold for anything else inside a list item after its
first paragraph — a code block, a second paragraph. With 2 the block
falls out of the list and splits it in two:

````markdown
- item text:

    ```modest
    let x = 1
    ```
````

(with a 2-space indent the HTML is `</li></ul><pre>…</pre><ul>`; with 4
the `<pre>` stays inside the `<li>`, aligned with its text).


## Warnings

`⚠️` marks only what is both dangerous and non-obvious — typically code
that compiles but silently does something other than expected. Anything
the compiler reports by itself needs no mark; ordinary caveats are notes.
Used rarely, the mark keeps catching the eye.

```markdown
⚠️ `Rational` is an exact fraction, not a float: `0.1 + 0.2 == 0.3` is true.
```
