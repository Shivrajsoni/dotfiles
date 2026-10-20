#!/usr/bin/env bash

sketchybar --add item front_app left \
  --set front_app script="$PLUGIN_DIR/front_app.sh" \
  icon="" \
  icon.color=$ACCENT \
  label.color=$WHITE \
  --subscribe front_app front_app_switched
