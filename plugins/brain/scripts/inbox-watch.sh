#!/usr/bin/env bash
# Emit one line per NEW open brain handoff. For the Monitor tool (stdout = events).
#
# Usage: brain-inbox-watch.sh [role] [poll_seconds]   role empty = all mail
#   BRAIN_WATCH_SSE=1   stream GET /v1/handoffs/stream instead of polling (needs a
#                       role; ~1s latency). Reconnects on drop, and re-reads the
#                       inbox on every (re)connect because the stream is future-only.
#   BRAIN_WATCH_BACKLOG=1  also emit the handoffs that already exist at startup.
#   BRAIN_TOKEN         bearer token. REQUIRED against a gated brain (ADR-0021 §2):
#                       /mcp and /v1/* both 401 without a caller. Only /healthz,
#                       /.well-known/*, /auth/* and */plugins.git are public.
#                       Falls back to ~/.claude/brain-watch-token (mint one with
#                       the create_api_token MCP tool, save it chmod 600).
#
# ponytail: poll is the default because a blip costs one cycle, where a dropped
# stream costs the watcher. SSE is opt-in for when 30s is too slow.
role="${1:-}"
sleep_s="${2:-30}"
base="${BRAIN_URL:-https://brain.levirge.com}"
token_file="${BRAIN_TOKEN_FILE:-$HOME/.claude/brain-watch-token}"
[ -z "${BRAIN_TOKEN:-}" ] && [ -f "$token_file" ] && BRAIN_TOKEN=$(<"$token_file")
auth=()
[ -n "${BRAIN_TOKEN:-}" ] && auth=(-H "Authorization: Bearer $BRAIN_TOKEN")
seen=$(mktemp)
to_arg=$([ -n "$role" ] && printf '"to":"%s",' "$role")
fail=0
first=${BRAIN_WATCH_BACKLOG:+0}; first=${first:-1}   # first pass seeds silently

# One inbox read -> emit unseen handoffs. Returns 1 if the read itself failed.
poll_once() {
  local body items
  body=$(curl -s -m 20 -X POST "$base/mcp" "${auth[@]}" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json, text/event-stream' \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"inbox\",\"arguments\":{${to_arg}\"status\":\"open\",\"limit\":25}}}") || body=""

  if [ -z "$body" ] || printf '%s' "$body" | grep -q '"error"'; then
    if [ "$fail" -eq 0 ]; then                                    # once per outage
      case "$body" in
        *Unauthorized*|*unauthorized*)
          echo "brain inbox poll FAILED: 401 from $base — mint a token with the create_api_token MCP tool and save it to $token_file (chmod 600)" ;;
        *) echo "brain inbox poll FAILED: ${body:-no response}" ;;
      esac
    fi
    fail=1
    return 1
  fi
  fail=0

  items=$(printf '%s' "$body" | sed -n 's/^data: //p' |
    jq -r '.result.structuredContent.items[]? | "\(.id)\t\(.to)\t\(.from): \(.subject)"' 2>/dev/null)
  printf '%s\n' "$items" | while IFS=$'\t' read -r id to rest; do
    [ -n "$id" ] || continue
    grep -qxF "$id" "$seen" && continue
    echo "$id" >>"$seen"
    [ "$first" -eq 1 ] || echo "handoff $id -> $to | $rest"
  done
  first=0
}

if [ -n "${BRAIN_WATCH_SSE:-}" ]; then
  [ -n "$role" ] || { echo "BRAIN_WATCH_SSE needs a role argument"; exit 2; }
  while true; do
    poll_once                                    # covers the gap: stream is future-only
    curl -sN "${auth[@]}" "$base/v1/handoffs/stream?to=$role" 2>/dev/null |
      while IFS= read -r line; do
        case "$line" in
          data:\ \{*)
            payload="${line#data: }"
            id=$(printf '%s' "$payload" | jq -r '.id // empty' 2>/dev/null)
            [ -n "$id" ] || continue
            grep -qxF "$id" "$seen" && continue      # already seen via poll_once
            echo "$id" >>"$seen"
            printf '%s' "$payload" |
              jq -r '"handoff \(.id) -> \(.to) | \(.from): \(.subject)"' 2>/dev/null
            ;;
        esac
      done
    sleep 5                                      # stream ended (drop/restart) — reconnect
  done
fi

while true; do
  poll_once
  sleep "$sleep_s"
done
