#!/usr/bin/env bash
# Create (or reuse) a numbered session and switch to it.
#   session-new.sh marketplace ~/git/SLB/marketplace  -> "03-marketplace" (next free number)
#   session-new.sh 12-tmp                              -> keeps the number you typed
# Usage: session-new.sh <name> [start-dir]
set -uo pipefail

name=${1:-}
dir=${2:-}
if [[ -z $name ]]; then
  tmux display-message "session-new: a name is required"
  exit 0
fi

if [[ ! $name =~ ^[0-9]+- ]]; then
  # a session with this name already exists under some number -> just go there
  existing=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | awk -v b="$name" '{ s = $0; sub(/^[0-9]+-/, "", s) } s == b { print; exit }')
  if [[ -n $existing ]]; then
    if [[ -n ${TMUX:-} ]]; then tmux switch-client -t "=$existing"; else tmux attach-session -t "=$existing"; fi
    exit 0
  fi
  used=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | sed -nE 's/^0*([0-9]+).*/\1/p')
  n=1
  while grep -qx "$n" <<<"$used"; do n=$((n + 1)); done
  name=$(printf '%02d-%s' "$n" "$name")
fi

dir=${dir:-$HOME}
dir=${dir/#\~/$HOME}
[[ -d $dir ]] || dir=$HOME

tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
if [[ -n ${TMUX:-} ]]; then tmux switch-client -t "=$name"; else tmux attach-session -t "=$name"; fi
