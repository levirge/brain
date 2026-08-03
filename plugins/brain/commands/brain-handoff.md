---
description: Send a handoff (arg: <from> <to> <subject>)
  argument-hint: <from> <to> <subject…>
---

Parse `$ARGUMENTS` as `<from> <to> <subject…>`. If any are missing, ask the user one short question
to fill them. Identities are `role@project` (e.g. `coder@brain`), optional `:instance` suffix —
normalise bare or `project:role` forms before sending.

Compose a handoff to **<to>** based on what the current conversation makes clear is the content (a
question, FYI, request for review, follow-up). Use markdown, keep it tight (a few short paragraphs),
include any concrete file paths, ids, or commands the recipient will need.

Then call `mcp__brain__handoff` with `action="send"`, `to`, `from`, `subject`, and
`body=<your composed message>`.

Report back the handoff id and a one-line summary of what you sent.
