#!/usr/bin/env bash

source "$SKETCHYBAR_CONFIG_DIR/variables.sh" # Loads all defined colors

AEROSPACE_PATH="/opt/homebrew/bin/aerospace"

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED_WORKSPACE=$($AEROSPACE_PATH list-workspaces --focused)
  if [ "$FOCUSED_WORKSPACE" = "$SID" ]; then
    sketchybar --animate tanh 5 --set "$NAME" \
      background.border_color="$MAGENTA"
  else
    sketchybar --animate tanh 5 --set "$NAME" \
      background.border_color="$COMMENT"
  fi
fi

if [ "$SENDER" = "mouse.clicked" ]; then
  $AEROSPACE_PATH workspace "$SID"
fi

