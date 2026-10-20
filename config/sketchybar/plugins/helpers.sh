#!/usr/bin/env bash
# Shared by plugins: loads theme and provides hover().
source "${SKETCHYBAR_CONFIG_DIR:-$HOME/.config/sketchybar}/variables.sh"

# Returns 0 (and highlights/unhighlights the item) for hover events.
hover() {
  case "$SENDER" in
    mouse.entered) sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE1" ;;
    mouse.exited)  sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE0" ;;
    *) return 1 ;;
  esac
}
