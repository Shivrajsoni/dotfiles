#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item clock right \
  --set clock update_freq=1 \
  updates=on \
  icon.padding_left=10 \
  icon.color="$COLOR" \
  icon="" \
  label.color="$COLOR" \
  label.padding_right=10 \
  background.color=0x00000000 \
  background.border_color=$COMMENT \
  background.border_width=1 \
  background.corner_radius=$CORNER_RADIUS \
  background.height=26 \
  script="$PLUGIN_DIR/clock.sh"
