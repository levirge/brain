---
description: Finish a Brain work session by capturing learnings, feedback, and handoffs
argument-hint: [from=<role>] [vault=<default-vault>]
---

Review the current conversation for:

- durable project-specific learnings that should outlive the session
- search results that were genuinely helpful
- search results that were dead ends
- handoffs another role should receive

Parse `$ARGUMENTS` for optional `from=<role>` and `vault=<default-vault>`. Then call
`mcp__brain__work_session` with `action="finish"` and:

- `from`, if supplied
- `capture_vault`, if supplied
- `learnings`, only for durable non-obvious project-specific facts
- `helpful_results` and `dead_end_results`, if the conversation contains concrete query/doc id pairs
- `handoffs`, only if there is a clear recipient and message

Report what was captured, feedback counts, and any handoff ids sent.
