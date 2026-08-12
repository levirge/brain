---
description: Show reminders that are due, or set one (arg: [7d|30d] | <vault> <date> <what>)
  argument-hint: [7d|30d] | <vault> <yyyy-mm-dd> <what to remember>
---

Parse `$ARGUMENTS`:

- **Empty, or a window like `7d` / `30d` / `next week`** → list. Call `mcp__brain__reminder` with
  `action="list"`, and `within_days=<n>` when a window was given (7 for a week, 30 for a month).
  Omit `within_days` entirely for "what is due right now" — do NOT pass 0.
- **`<vault> <yyyy-mm-dd> <what>`** → set one. Call `mcp__brain__reminder` with `action="add"`,
  `vault`, `due`, and `title=<what>`. `due` is required; if the user gave no date, ask for one
  rather than inventing a plausible-looking default.

When listing, format compactly, oldest due first:

- `{title} — due {due}` plus `overdue {overdue_days}d` when that is above zero.
- Say which window the answer covers, using the `through` field: "nothing due today" and "nothing
  due this month" are different answers and must not be reported as the same one.
- If a reminder has `links`, name the linked doc id — the reminder points at the knowledge rather
  than repeating it, so that id is where the detail lives.

If nothing is due, say so in one line, including the window checked.

A reminder is "don't forget about this" — it stays invisible until its date. For work that needs
doing now, use the `todo` tool instead.
