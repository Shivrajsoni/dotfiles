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
  "mouse.clicked")
    open "x-apple.systempreferences:com.apple.preference.battery"
    ;;
  *)
    PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
    CHARGING="$(pmset -g batt | grep 'AC Power')"

    if [ "$PERCENTAGE" = "" ]; then
      exit 0
    fi

    case "${PERCENTAGE}" in
      9[0-9]|100) ICON=""
      ;;
      [6-8][0-9]) ICON=""
      ;;
      [3-5][0-9]) ICON=""
      ;;
      [1-2][0-9]) ICON=""
      ;;
      *) ICON=""
    esac

    if [[ "$CHARGING" != "" ]]; then
      ICON=""
    fi

    sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
    ;;
esac
