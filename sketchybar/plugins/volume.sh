#!/bin/sh

SURFACE1="${SURFACE1:-0xff45475a}"
SURFACE0="${SURFACE0:-0xff313244}"

case "$SENDER" in
  "mouse.entered")
    sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE1"
    ;;
  "mouse.exited")
    sketchybar --animate tanh 10 --set "$NAME" background.color="$SURFACE0"
    ;;
  "mouse.scrolled.up")
    osascript -e 'set volume output volume (output volume of (get volume settings) + 5)'
    ;;
  "mouse.scrolled.down")
    osascript -e 'set volume output volume (output volume of (get volume settings) - 5)'
    ;;
  *)
    VOLUME=$(osascript -e 'output volume of (get volume settings)')
    MUTED=$(osascript -e 'output muted of (get volume settings)')

    if [ "$MUTED" = "true" ]; then
      ICON="󰖁" # Speaker muted
      LABEL="0%"
    else
      case $VOLUME in
        100) ICON="󰕾" ;;
        [6-9][0-9]) ICON="󰕾" ;; # Speaker high
        [3-5][0-9]) ICON="󰖀" ;; # Speaker mid
        [1-9]|[1-2][0-9]) ICON="󰕿" ;; # Speaker low
        *) ICON="󰖁" # Speaker muted / 0
      esac
      LABEL="${VOLUME}%"
    fi

    sketchybar --set $NAME icon="$ICON" label="$LABEL"
    ;;
esac