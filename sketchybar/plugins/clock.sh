#!/usr/bin/env bash

source "$HOME/dotfiles/sketchybar/variables.sh"

case "$SENDER" in
  "mouse.entered")
    sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE1"
    ;;
  "mouse.exited")
    sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE0"
    ;;
  "mouse.clicked")
    open -a Calendar
    ;;
  *)
    LABEL=$(date '+%a %b %d  %H:%M')
    sketchybar --set "$NAME" label="$LABEL"
    ;;
esac
