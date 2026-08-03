---
description: Start a Brain work session with overview, context, and inbox
argument-hint: [role=<role>] [vault:...|entity:...|doc:...|query:...]
---

Parse `$ARGUMENTS` for an optional `role=<role>` and optional root spec:

- `vault:<name>`
- `entity:<name>`
- `doc:<id>`
- `query:<text>`

Call `mcp__brain__start_work_session` with the role if present, the parsed root if present,
`context_format="markdown"`, and `budget_tokens=4000`.

Report the adopted role, open inbox count, KB readiness/revision, and the most useful context
bullets before continuing the user's task.

For the rest of the session, follow the Brain grounding contract (binding — measured to double
retrieval compliance on small host models, harmless on frontier models):

- When a question concerns architecture, runbooks, prior decisions, or system behavior, call
  `search_knowledge` BEFORE answering — do not answer such questions from memory.
- Ground answers in returned results only; cite material claims inline as `[source-id]` using
  only IDs present in the results. If evidence is insufficient, say what is missing rather than
  filling the gap.
