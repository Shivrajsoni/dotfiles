#!/usr/bin/env bash

sketchybar \
  --add item front_app left \
  --set front_app script="$PLUGIN_DIR/front_app.sh" \
  icon="" \
  icon.font="$FONT:Bold:16.0" \
  icon.color="$CYAN" \
  icon.padding_left=10 \
  label.color="$WHITE" \
  label.padding_right=10 \
  background.height=26 \
  background.color=0x00000000 \
  background.border_color=$COMMENT \
  background.border_width=1 \
  background.corner_radius="$CORNER_RADIUS" \
  background.padding_right=5 \
  associated_display=active \
  --subscribe front_app front_app_switched
