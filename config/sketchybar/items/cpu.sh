#!/usr/bin/env bash

COLOR="$YELLOW"
sketchybar --add item cpu right \
  --set cpu \
  update_freq=3 \
  icon= \
  icon.color="$COLOR" \
  label.color="$COLOR" \
  script="$PLUGIN_DIR/cpu.sh"
