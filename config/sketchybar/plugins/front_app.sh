#!/usr/bin/env bash

source "${SKETCHYBAR_CONFIG_DIR:-$HOME/.config/sketchybar}/variables.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  APP="$INFO"
else
  APP=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)
fi

sketchybar --set "$NAME" label="${APP:-Desktop}"
