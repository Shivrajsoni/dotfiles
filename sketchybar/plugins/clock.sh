#!/usr/bin/env bash

SURFACE1="${SURFACE1:-0xff45475a}"
SURFACE0="${SURFACE0:-0xff313244}"

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
