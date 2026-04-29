#!/usr/bin/env bash

source "${SKETCHYBAR_CONFIG_DIR:-$HOME/dotfiles/sketchybar}/variables.sh"

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
    VOL_INFO=$(osascript -e 'set vol to get volume settings' -e 'return (output volume of vol as string) & "," & (output muted of vol as string)')
    VOLUME=$(echo "$VOL_INFO" | cut -d',' -f1)
    MUTED=$(echo "$VOL_INFO" | cut -d',' -f2)

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