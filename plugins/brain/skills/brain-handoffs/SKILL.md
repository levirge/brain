---
name: brain-handoffs
description: Agent-to-agent handoffs via the brain MCP server — adopt a role identity, check the inbox, send a handoff to another agent, or reply to one. Use when the user says "check my handoffs", "hand this off to <role>", "reply to that handoff", or names a brain identity/role to work as.
---

# Brain handoffs

Async agent-to-agent messaging over the `brain` MCP server. A _handoff_ is a markdown message
addressed to an identity; agents poll or wait on their identity's inbox.

## Identity pattern (canonical)

Identities are **`role@project`** — e.g. `coder@brain`, `admin@levirge`, `payments@mrs`. Optional
`:instance` suffix when several copies of the same role run in parallel: `coder@brain:wt-a1b2`. Do
not use bare roles (`coder`) or the inverted `project:role` form (`brain:auth`) — routing sanitises
separators to `_`, so `auth@brain` and `brain:auth` are _different_ mailboxes; pick the canonical
spelling and stay on it.

## Adopt an identity (do this first)

The user names an identity (normalise it to `role@project` if they give a shorthand). Remember it
for the session and pass it as `from` on every brain tool call that takes one (`handoff`
sends/replies, `feedback`).

Then call `handoff` with `action="inbox"` and `to=<role>` to surface pending handoffs. Report the
identity adopted and any open handoffs (subject + sender, oldest first).

To receive handoffs that arrive later, spawn the listener agent —
`Agent(subagent_type: "brain:brain-listener", prompt: "<role>")`. It long-polls `handoff`
(`action="wait"`) over the session's own authenticated MCP connection (no credentials, no scripts)
and wakes the session via its completion notification when a handoff arrives. After handling each
wake, IMMEDIATELY resume it with `SendMessage("resume listening")` — handle-then-resume, every time.
Gaps are safe (backlog delivery covers handoffs that arrive while it is down), but only if you
resume. Never call `handoff` with `action="wait"` from the main session — it blocks the session;
that call belongs to the listener.

Fallback when the Agent tool is unavailable or the listener keeps erroring:
`Monitor(command: "bash ~/.claude/brain-inbox-watch.sh <role> 30",
persistent: true)`. The script
curls brain directly, so it needs its own bearer: it reads `~/.claude/brain-watch-token`. If that
file is missing, call the `create_api_token` tool (label `"inbox-watch <hostname>"`), write the raw
token there, `chmod 600` it — one-time per machine. Never scrape MCP client config or keychains for
a token.

## Check the inbox

Call `handoff` with `action="inbox"`, `to=<role>`, and `status` (`open` | `replied` | `all`, default
open). Format as a compact list, newest first:

- `{id} from {from} — "{subject}"` plus a relative timestamp
- highlight items where `replied_at` is null (still requiring action)
- flag open handoffs older than 1 hour as "stale — likely needs follow-up"

If empty, say so in one line.

## Send a handoff

Needs `<from> <to> <subject>` — ask one short question if any is missing. Compose the body from what
the current conversation makes clear (a question, FYI, review request, follow-up). Markdown, tight
(a few short paragraphs), include concrete file paths, ids, or commands the recipient will need.

Call `handoff` with `action="send"`, `to`, `from`, `subject`, `body`. Report the handoff id and a
one-line summary of what was sent.

## Reply to a handoff

Needs `<from> <handoff_id>` — ask one short question if either is missing. Compose the reply from
the current conversation; if the content isn't clear, ask one short question to nail it down,
otherwise just send.

Call `handoff` with `action="reply"`, `handoff_id`, `from`, `body`. Report confirmation, the
original subject, and the new reply id.
