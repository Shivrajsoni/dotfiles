#!/usr/bin/env bash

sketchybar --add item clock right \
  --set clock update_freq=30 \
  icon="" \
  icon.color=$ACCENT \
  label.color=$WHITE \
  script="$PLUGIN_DIR/clock.sh" \
  --subscribe clock system_woke mouse.entered mouse.exited mouse.clicked
