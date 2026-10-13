---
description: Set your brain identity for this session, check inbox, and watch it in the background
argument-hint: <role>
---

Your brain identity for this session is **$ARGUMENTS**. Remember it for every subsequent brain tool
call that takes a `from` field (`handoff` sends/replies, `feedback`).

Identities are canonically `role@project` (e.g. `coder@brain`, `admin@levirge`), with an optional
`:instance` suffix for parallel copies (`coder@brain:wt-a1b2`). If $ARGUMENTS is a bare role or a
`project:role` form, tell the user the canonical spelling and use it — differently-spelled
identities are different mailboxes.

Now call brain's `handoff` tool with action="inbox" and to="$ARGUMENTS" to surface any pending
handoffs.

## Arm the listener (default)

Spawn the background listener agent — do this now, before any other work, and only once per session.

**Pass the tool name you just used.** You resolved brain's handoff tool for the inbox call above, so
you already know its exact name (the prefix differs between installs — `mcp__brain__…`,
`mcp__plugin_brain_brain__…`, or `mcp__<uuid>__…`). Handing it over means the listener never has to
discover it, which is the one step that has silently hung a watch for an entire session:

```
Agent(subagent_type: "brain:brain-listener",
      prompt: "$ARGUMENTS\ntool: <exact handoff tool name you just called>",
      description: "brain inbox: $ARGUMENTS")
```

It long-polls `handoff` (`action="wait"`) over this session's own authenticated MCP connection — no
extra credentials, no scripts. It runs in the background; when a handoff arrives it completes and
its task notification wakes you with the handoff JSON.

**The resume habit — this is the one rule that keeps the watch alive.** When the listener's
notification arrives: read the handoff, act on it, reply with brain's `handoff` tool (action="reply",
from="$ARGUMENTS"), and then IMMEDIATELY resume the listener:

```
SendMessage(to: <listener agent>, summary: "resume listening", message: "resume listening")
```

Handle-then-resume, every time, even if the handoff needs no action. Gaps are safe — handoffs that
arrive while the listener is down are delivered instantly on the next wait (backlog delivery) — but
only if you actually resume. If the listener returns an error instead of a handoff, resume it once.

One error does NOT deserve a resume: `no handoff tool available` (or a timeout report citing
thousands of attempts in under a couple of minutes) means brain's MCP tools never resolved in the
subagent, so re-running it fails identically. Check the connection instead — `ToolSearch("+handoff")`
from this session confirms whether any handoff tool exists and under which prefix. If brain's tools
genuinely are not connected, say so and stop: there is no second watch path to fall back to.

**A silent listener is the failure mode to watch for.** A listener stuck resolving its tool reports
`running`, emits nothing, and never errors — indistinguishable from a quiet inbox for as long as you
care to wait (observed 2026-08-15: 53 minutes, zero deliveries, ~6 handoffs missed). Diagnose it from
the mailbox rather than the agent: call `handoff` with `action="inbox"` and compare `delivered_at`
across records. `wait` stamps that field the instant it hands a record over, so **recent handoffs
with no `delivered_at`, alongside older ones that have it, prove no waiter is being served** — the
watch is dead, not the inbox quiet. Kill and respawn with the `tool:` line above; a healthy listener
returns the oldest backlog item within seconds.

Treat a wake as work to do, not a notice to relay. Confirm reply text with the user before sending
unless they have said to auto-reply.

Do NOT call brain's `handoff` tool with `action="wait"` from the main session — it blocks the session
doing nothing. That tool belongs to the listener agent.

## No Agent tool available?

Then there is no background watch — say so rather than improvising one. Check the inbox directly
with brain's `handoff` tool (`action="inbox"`) at natural points in the work instead.

Report back: the identity you adopted, that the listener is armed (and which mode), and any open
handoffs (subject + sender, oldest first).
