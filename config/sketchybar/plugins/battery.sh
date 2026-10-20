#!/usr/bin/env bash

source "$(dirname "$0")/helpers.sh"

hover && exit 0
[ "$SENDER" = "mouse.clicked" ] && { open "x-apple.systempreferences:com.apple.Battery-Settings.extension"; exit 0; }

BATT_INFO="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT_INFO" | grep -Eo '[0-9]+%' | head -n1 | cut -d% -f1)"

# No battery (desktop Mac): hide the item.
if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if echo "$BATT_INFO" | grep -q 'AC Power'; then CHARGING=1; else CHARGING=0; fi

case "$PERCENTAGE" in
  9[0-9]|100) ICON="" ;;
  [6-8][0-9]) ICON="" ;;
  [3-5][0-9]) ICON="" ;;
  [1-2][0-9]) ICON="" ;;
  *)          ICON="" ;;
esac

COLOR=$WHITE
[ "$PERCENTAGE" -le 20 ] && COLOR=$RED
if [ "$CHARGING" = 1 ]; then ICON=""; COLOR=$GREEN; fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
