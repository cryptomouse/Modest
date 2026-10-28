# Value Evaluation Statement

Evaluates an expression for its side effects; the result is discarded.

## Form

```
<#value_expression#>
```

## Semantics

- The usual case is a function call whose result is not needed.
- Discarding a value may produce an unused-value warning; discard
  explicitly by constructing `Unit` from it (see
  [value construction](../value/cons.md)).

## Examples

```modest
func hi () -> Unit {
	printf("Hi there!\n")     // result of printf discarded
}

func foo () -> Unit {
	2 + 2  // explicitly discard expression result
}

func handler (payload: Ptr) -> Unit {
	Unit payload          // explicitly discard unused parameter
}

```
