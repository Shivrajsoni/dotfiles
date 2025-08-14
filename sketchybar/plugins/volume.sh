#!/bin/sh

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