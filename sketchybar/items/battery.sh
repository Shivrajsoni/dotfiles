#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item battery right \
  --set battery \
  update_freq=60 \
  icon.color="$COLOR" \
  icon.padding_left=10 \
  label.padding_right=10 \
  label.color="$COLOR" \
  background.color=0x00000000 \
  background.border_color=$COMMENT \
  background.border_width=1 \
  background.corner_radius=$CORNER_RADIUS \
  background.height=26 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery power_source_change
