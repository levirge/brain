---
description: Show open handoffs for your role (arg: <role> [status])
argument-hint: <role> [open|replied|all]
---

Parse `$ARGUMENTS` as `<role> [open|replied|all]` (status defaults to open). Call `mcp__brain__inbox` with `to=<role>` and `status=<status>`. Format the result as a compact list, newest first:

- For each handoff: `{id} from {from} — "{subject}"` plus a relative timestamp.
- Highlight items where replied_at is null (still requiring action).
- Flag any open handoff older than 1 hour as "stale — likely needs reply or follow-up".

If empty, say so in one line.
