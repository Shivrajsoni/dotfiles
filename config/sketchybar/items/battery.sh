#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item battery right \
  --set battery \
  update_freq=60 \
  icon.color="$COLOR" \
  label.color="$COLOR" \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery power_source_change mouse.entered mouse.exited mouse.clicked
