#!/usr/bin/env bash
# Aerospace workspace indicator: highlight focused space, switch on click.
# Robust: no external source, derive SID from NAME, fallback colors if env missing.

NAME="${NAME:?}"
SID="${NAME#space.}"
# Fallback colors when variables.sh not loaded
MAGENTA="${MAGENTA:-0xffc6a0f6}"
SURFACE0="${SURFACE0:-0xff313244}"
SURFACE1="${SURFACE1:-0xff45475a}"
BASE="${BASE:-0xff1e1e2e}"
WHITE="${WHITE:-0xffcad3f5}"
AEROSPACE_PATH="${AEROSPACE_PATH:-/opt/homebrew/bin/aerospace}"

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED_WORKSPACE=""
  [ -x "$AEROSPACE_PATH" ] && FOCUSED_WORKSPACE=$("$AEROSPACE_PATH" list-workspaces --focused 2>/dev/null) || true
  if [ "$FOCUSED_WORKSPACE" = "$SID" ]; then
    sketchybar --animate tanh 5 --set "$NAME" \
      background.color="$MAGENTA" \
      background.border_color="$MAGENTA" \
      label.color="$BASE"
  else
    sketchybar --animate tanh 5 --set "$NAME" \
      background.color="$SURFACE0" \
      background.border_color="$SURFACE1" \
      label.color="$WHITE"
  fi
fi

if [ "$SENDER" = "mouse.clicked" ]; then
  [ -x "$AEROSPACE_PATH" ] && "$AEROSPACE_PATH" workspace "$SID" 2>/dev/null || true
fi
