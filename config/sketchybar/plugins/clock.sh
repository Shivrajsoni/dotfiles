#!/usr/bin/env bash

source "$(dirname "$0")/helpers.sh"

hover && exit 0
[ "$SENDER" = "mouse.clicked" ] && { open -a Calendar; exit 0; }

sketchybar --set "$NAME" label="$(date '+%a %d %b  %H:%M')"
