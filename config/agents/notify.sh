#!/bin/bash
set -euo pipefail

INPUT=$(cat)
MESSAGE="$1"
SOUND="$2"
PROJECT=$(basename "${CLAUDE_PROJECT_DIR:-$PWD}")

EXECUTE="osascript -e 'tell application \"Alacritty\" to activate'"

if [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ]; then
  # -execute runs with a minimal PATH that lacks Homebrew, so use the absolute
  # tmux path. Anchor on TMUX_PANE: without an explicit target, display-message
  # reports the attached client's active pane, not the pane running this hook.
  # switch-client makes the click work even from another session.
  TMUX_BIN=$(command -v tmux)
  WINDOW_ID=$(tmux display-message -t "$TMUX_PANE" -p '#{window_id}')
  EXECUTE="${EXECUTE} && ${TMUX_BIN} select-window -t '${WINDOW_ID}' && ${TMUX_BIN} select-pane -t '${TMUX_PANE}' && ${TMUX_BIN} switch-client -t '${WINDOW_ID}'"
fi

if [ -x "$(command -v terminal-notifier)" ]; then
  terminal-notifier \
    -title "Claude Code" \
    -subtitle "in $PROJECT" \
    -message "$MESSAGE" \
    -sound "$SOUND" \
    -execute "$EXECUTE"
fi
