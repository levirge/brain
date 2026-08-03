---
description: Fetch an agent context pack (arg: <vault:...|entity:...|doc:...|query:...> [json|markdown])
  argument-hint: <vault:...|entity:...|doc:...|query:...> [json|markdown]
---

Parse `$ARGUMENTS` as one root spec and optional format. The root spec must be exactly one of:

- `vault:<name>`
- `entity:<name>`
- `doc:<id>`
- `query:<text>`

Default format is `markdown`. Call `mcp__brain__get_context_pack` with the parsed root, `format`,
and default `depth=2`.

Report a compact orientation summary: root, confidence or coverage if present, top entities or hits,
notable graph edges, and the next Brain tool you would call if more detail is needed.
