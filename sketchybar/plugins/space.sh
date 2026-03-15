#!/usr/bin/env bash
# Aerospace workspace indicator: highlight focused space, switch on click.
# Robust: no external source, derive SID from NAME, fallback colors if env missing.

NAME="${NAME:?}"
SID="${NAME#space.}"
# Fallback colors when variables.sh not loaded (e.g. daemon context)
MAGENTA="${MAGENTA:-0xffc6a0f6}"
COMMENT="${COMMENT:-0xff939ab7}"
AEROSPACE_PATH="${AEROSPACE_PATH:-/opt/homebrew/bin/aerospace}"

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED_WORKSPACE=""
  [ -x "$AEROSPACE_PATH" ] && FOCUSED_WORKSPACE=$("$AEROSPACE_PATH" list-workspaces --focused 2>/dev/null) || true
  if [ "$FOCUSED_WORKSPACE" = "$SID" ]; then
    sketchybar --animate tanh 5 --set "$NAME" background.border_color="$MAGENTA"
  else
    sketchybar --animate tanh 5 --set "$NAME" background.border_color="$COMMENT"
  fi
fi

if [ "$SENDER" = "mouse.clicked" ]; then
  [ -x "$AEROSPACE_PATH" ] && "$AEROSPACE_PATH" workspace "$SID" 2>/dev/null || true
fi
