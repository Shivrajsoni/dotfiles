#!/usr/bin/env bash

COLOR="$YELLOW"
sketchybar --add item cpu right \
  --set cpu \
  update_freq=3 \
  icon= \
  icon.color="$COLOR" \
  icon.padding_left=10 \
  label.color="$COLOR" \
  label.padding_right=10 \
  background.color=0x00000000 \
  background.border_color=$COMMENT \
  background.border_width=1 \
  background.corner_radius=$CORNER_RADIUS \
  background.height=26 \
  script="$PLUGIN_DIR/cpu.sh"
