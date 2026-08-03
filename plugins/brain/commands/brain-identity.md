---
description: Set your brain identity for this session, check inbox, and watch it in the background
argument-hint: <role>
---

Your brain identity for this session is **$ARGUMENTS**. Remember it for every subsequent brain tool
call that takes a `from` field (send_handoff, reply_handoff, mark_helpful, mark_dead_end).

Identities are canonically `role@project` (e.g. `coder@brain`, `admin@levirge`), with an optional
`:instance` suffix for parallel copies (`coder@brain:wt-a1b2`). If $ARGUMENTS is a bare role or a
`project:role` form, tell the user the canonical spelling and use it — differently-spelled
identities are different mailboxes.

Now call `mcp__brain__inbox` with to="$ARGUMENTS" to surface any pending handoffs.

## Arm the listener (default)

Spawn the background listener agent — do this now, before any other work, and only once per session:

```
Agent(subagent_type: "brain:brain-listener", prompt: "$ARGUMENTS",
      description: "brain inbox: $ARGUMENTS")
```

It long-polls `wait_for_handoff` over this session's own authenticated MCP connection — no extra
credentials, no scripts. It runs in the background; when a handoff arrives it completes and its
task notification wakes you with the handoff JSON.

**The resume habit — this is the one rule that keeps the watch alive.** When the listener's
notification arrives: read the handoff, act on it, reply with `mcp__brain__reply_handoff`
(from="$ARGUMENTS"), and then IMMEDIATELY resume the listener:

```
SendMessage(to: <listener agent>, summary: "resume listening", message: "resume listening")
```

Handle-then-resume, every time, even if the handoff needs no action. Gaps are safe — handoffs that
arrive while the listener is down are delivered instantly on the next wait (backlog delivery) — but
only if you actually resume. If the listener returns an error instead of a handoff, resume it once;
if it errors again, fall back to the script watcher below.

Treat a wake as work to do, not a notice to relay. Confirm reply text with the user before sending
unless they have said to auto-reply.

Do NOT call `mcp__brain__wait_for_handoff` from the main session — it blocks the session doing
nothing. That tool belongs to the listener agent.

## Fallback: script watcher (no Agent tool, or listener keeps failing)

The script needs its own bearer (brain gates /mcp and /v1 — ADR-0021 §2). It reads
`~/.claude/brain-watch-token` automatically. If that file is missing, mint one over the MCP channel
you already hold — do NOT go digging in MCP client config or keychains for a token:

1. Call `mcp__brain__create_api_token` with label `"inbox-watch <hostname>"`.
2. Save it: write the raw token to `~/.claude/brain-watch-token`, then `chmod 600` it.

One-time per machine — the token is durable, and revocable in brain Settings. Then:

```
Monitor(command: "bash ~/.claude/brain-inbox-watch.sh $ARGUMENTS 30",
        description: "brain inbox: $ARGUMENTS", persistent: true)
```

It polls every 30s and emits one line per **new** handoff (the current backlog is seeded silently).
If that path does not exist, copy it once from
`~/.claude/plugins/marketplaces/brain/plugins/brain/scripts/inbox-watch.sh`. A 401 means the saved
token was revoked — mint a fresh one and re-arm; do not retry the same token. For ~1s latency,
prefix with `BRAIN_WATCH_SSE=1` (streams `/v1/handoffs/stream`, re-reads inbox on reconnect).

Report back: the identity you adopted, that the listener is armed (and which mode), and any open
handoffs (subject + sender, oldest first).
