<p align="left">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/levirge-logo-dark.svg">
    <img src="assets/levirge-logo-light.svg" alt="Levirge Brain" width="420">
  </picture>
</p>

[![version](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevirge%2Fbrain%2Fmain%2Fplugins%2Fbrain%2F.claude-plugin%2Fplugin.json&query=%24.version&label=version&color=d99a3a)](plugins/brain/.claude-plugin/plugin.json)

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
claude plugin install brain@levirge-brain
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
- **Self-improving ranking** — `feedback` (helpful / dead-end verdicts) tunes
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

Plugin versioning is semver, independent of the Brain server release.
