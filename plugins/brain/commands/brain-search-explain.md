---
description: Explain Brain search results and retrieval confidence
argument-hint: <query>
---

Use all of `$ARGUMENTS` as the query. If empty, ask one short question.

Call `mcp__brain__explain_search` with `query=<query>`, `include_content="snippet"`, and default
`k=10`.

Summarize confidence, top score, rerank status, applied filters, and the top hits. Ground the
summary in the returned results only, citing hits inline as `[source-id]` with only IDs present in
the results. If confidence is low or empty, suggest a better next Brain call such as
`list_documents`, `list_vaults`, `list_entities`, or a more specific query.
