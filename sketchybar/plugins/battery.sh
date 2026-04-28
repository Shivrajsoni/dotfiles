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
    open "x-apple.systempreferences:com.apple.preference.battery"
    ;;
  *)
    BATT_INFO="$(pmset -g batt)"
    PERCENTAGE="$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1)"
    CHARGING="$(echo "$BATT_INFO" | grep 'AC Power')"

    if [ -z "$PERCENTAGE" ]; then
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
