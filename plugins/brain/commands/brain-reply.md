---
description: Reply to a handoff by id (arg: <from> <handoff_id>)
  argument-hint: <from> <handoff_id>
---

Parse `$ARGUMENTS` as `<from> <handoff_id>`. If either is missing, ask one short question.

Compose a reply to handoff **<handoff_id>** based on the current conversation. If the content of the
reply isn't clear yet, ask the user one short question to nail it down. Otherwise just send.

Then call `mcp__brain__handoff` with `action="reply"`, `handoff_id`, `from`, and
`body=<your composed reply>`.

Report back: confirmation, the original handoff's subject, and the new reply id.
