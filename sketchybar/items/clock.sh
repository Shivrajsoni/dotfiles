#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item clock right \
  --set clock update_freq=1 \
  updates=on \
  icon.color="$COLOR" \
  icon="" \
  label.color="$COLOR" \
  script="$PLUGIN_DIR/clock.sh" \
  --subscribe clock mouse.entered mouse.exited mouse.clicked
