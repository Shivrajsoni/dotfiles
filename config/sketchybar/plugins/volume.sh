#!/usr/bin/env bash

source "$(dirname "$0")/helpers.sh"

hover && exit 0

case "$SENDER" in
  mouse.clicked)
    osascript -e 'set volume output muted not (output muted of (get volume settings))'
    ;;
  mouse.scrolled)
    # SCROLL_DELTA is positive when scrolling up
    STEP=$(( ${SCROLL_DELTA:-0} > 0 ? 5 : -5 ))
    osascript -e "set volume output volume ((output volume of (get volume settings)) + ($STEP))"
    ;;
esac

IFS=, read -r VOLUME MUTED < <(osascript -e 'set v to get volume settings' \
  -e 'return (output volume of v as string) & "," & (output muted of v as string)')

if [ "$MUTED" = "true" ] || [ "${VOLUME:-0}" -eq 0 ]; then
  ICON="󰖁"; LABEL="muted"
else
  LABEL="${VOLUME}%"
  if   [ "$VOLUME" -ge 60 ]; then ICON="󰕾"
  elif [ "$VOLUME" -ge 30 ]; then ICON="󰖀"
  else ICON="󰕿"; fi
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
