#!/usr/bin/env bash
# Give the current session a number, keeping its name: "marketplace" or "07-marketplace" -> "02-marketplace".
# Refuses if another session already uses that number.
# Usage: session-number.sh <number>
set -uo pipefail

want=${1:-}
if [[ ! $want =~ ^[0-9]+$ ]]; then
  tmux display-message "session-number: '$want' is not a number"
  exit 0
fi
want=$((10#$want))

current=$(tmux display-message -p '#S')
if [[ $current =~ ^[0-9]+-(.*)$ ]]; then base=${BASH_REMATCH[1]}; else base=$current; fi
new=$(printf '%02d-%s' "$want" "$base")

taken=$(tmux list-sessions -F '#{session_name}' |
  awk -v n="$want" -v cur="$current" '$0 != cur && match($0, /^[0-9]+/) && substr($0, 1, RLENGTH) + 0 == n { print; exit }')
if [[ -n $taken ]]; then
  tmux display-message "Number $(printf '%02d' "$want") is already used by '$taken'"
  exit 0
fi

tmux rename-session -t "=$current" "$new"
