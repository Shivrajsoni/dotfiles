#!/usr/bin/env bash

sketchybar \
  --add item front_app left \
  --set front_app script="$PLUGIN_DIR/front_app.sh" \
  icon="" \
  icon.font="$FONT:Bold:16.0" \
  icon.color="$CYAN" \
  label.color="$WHITE" \
  background.padding_right=5 \
  associated_display=active \
  --subscribe front_app front_app_switched
