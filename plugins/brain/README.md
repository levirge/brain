# Brain plugin

Agent workflows over the Brain MCP server: work sessions, context packs, search explanation, fact
lineage, and agent-to-agent handoffs. Commands install as `/brain:start`,
`/brain:context`, etc.

## Host-model guidance (measured)

Brain works best with models that search before answering and cite what they read. From the 2026-07
agent bake-off (10 KB tasks × 3 repeats, fixed judge — full report in the KB, doc
`a22b061c349c9403`):

- **Good Brain citizens:** Claude Opus-class (perfect grounding), `z-ai/glm-5.2` (Claude-class
  grounding at ~1/10 cost), `poolside/laguna-xs` (fastest tie).
- **Small/local models work, with conditions:** they treat permissive tool instructions as optional.
  The `/brain:start` command now embeds a binding search-first + grounding contract; keep it
  in context. Measured effect: doubled retrieval compliance on a 26B, halved hallucinated claims on
  a 9B.
- **Avoid retrieve-then-ignore models** for KB work: in the same eval, `openai/gpt-oss-120b`
  searched the most (1.47 calls/task) and grounded the least (78 unsupported claims across 30
  records).

## Contract summary

1. Questions about architecture, runbooks, prior decisions, or system behavior → call
   `search_knowledge` BEFORE answering; never from memory.
2. Answer only from returned results; cite claims inline as `[source-id]`; if evidence is
   insufficient, say what's missing instead of filling the gap.
3. Feed back: `feedback` with `verdict: "helpful"` for results you used, `verdict: "dead_end"` for
   plausible-but-wrong hits — this is what makes ranking self-improve.
