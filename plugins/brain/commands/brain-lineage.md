---
description: Inspect Brain fact lineage for a document or atom id
argument-hint: <doc_or_atom_id>
---

Parse `$ARGUMENTS` as `<doc_or_atom_id>`. If missing, ask one short question.

Call `mcp__brain__get_document` with `id=<doc_or_atom_id>` and `lineage=true`.

Summarize incoming edges, outgoing edges, derived atoms, and source docs. If an incoming `updates`
edge exists, say the fact may be superseded. If no lineage is present, say so plainly.
