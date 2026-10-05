#!/usr/bin/env bash
# Jump to the session whose name starts with a number: 2, 02 and 002 all match "02-marketplace".
# If no running session has that number but sesh.toml defines one, sesh starts it.
# Works inside tmux (switch) and from a plain terminal (attach).
# Usage: session-jump.sh <number>
set -uo pipefail

want=${1:-}
if [[ ! $want =~ ^[0-9]+$ ]]; then
  tmux display-message "session-jump: '$want' is not a number"
  exit 0
fi
want=$((10#$want))

# print the first line whose leading number equals $want
match() {
  awk -v n="$want" 'match($0, /^[0-9]+/) && substr($0, 1, RLENGTH) + 0 == n { print; exit }'
}

go() {
  if [[ -n ${TMUX:-} ]]; then tmux switch-client -t "=$1"; else tmux attach-session -t "=$1"; fi
}

target=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | match)
if [[ -n $target ]]; then
  go "$target"
  exit 0
fi

if command -v sesh >/dev/null 2>&1; then
  target=$(sesh list -c 2>/dev/null | match)
  if [[ -n $target ]]; then
    exec sesh connect "$target"
  fi
fi

msg="No session numbered $(printf '%02d' "$want")"
if [[ -n ${TMUX:-} ]]; then tmux display-message "$msg"; else echo "$msg" >&2; exit 1; fi
