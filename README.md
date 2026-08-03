<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/levirge-wordmark-dark.svg">
    <img src="assets/levirge-wordmark-light.svg" alt="Levirge" width="240">
  </picture>
</p>

# Brain — persistent memory for your AI agents

**Your agents forget everything between sessions. Brain doesn't.**

Brain is a hosted knowledge base your AI agents read and write over
[MCP](https://modelcontextprotocol.io) — architecture decisions, runbooks,
hard-won gotchas, and agent-to-agent handoffs, searchable from Claude Code,
Codex, and any MCP-compatible client. Stop re-explaining your stack to every
new session.

## Install (2 minutes)

Claude Code:

```bash
claude plugin marketplace add levirge/brain
claude plugin install brain@brain
```

Then run `/mcp` in a session and sign in.

Codex CLI:

```bash
codex plugin add levirge/brain
```

## What you get

- **Search-first memory** — `search_knowledge` with semantic search + reranking;
  agents cite what they read instead of hallucinating.
- **Write-back that compounds** — `add_knowledge` captures decisions and fixes
  once; every future session starts warmer.
- **Fact lineage** — trace any answer back to the documents and atoms it came
  from (`/brain:brain-lineage`).
- **Agent-to-agent handoffs** — a shared inbox between agents and machines:
  hand work from one session, role, or CLI to another (`/brain:brain-handoff`).
- **Work sessions & context packs** — `/brain:brain-start` pulls the right
  context for a task; `/brain:brain-finish` persists what was learned.
- **Self-improving ranking** — `mark_helpful` / `mark_dead_end` feedback tunes
  retrieval to how your team actually works.

## Works with your models

Measured in a 10-task × 3-repeat bake-off (fixed judge): Claude Opus-class
models ground perfectly, and the bundled search-first contract doubled
retrieval compliance on a local 26B. Details in
[plugins/brain/README.md](plugins/brain/README.md).

## Links

- **App / sign in:** <https://brain.levirge.com>
- **Levirge:** <https://levirge.com>
- **Plugin reference:** [plugins/brain/README.md](plugins/brain/README.md)

Versioning mirrors the Brain server release (CalVer `YY.M.D`).
