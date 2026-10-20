#!/usr/bin/env bash

# Scroll to change volume, click to mute.
sketchybar --add item sound right \
  --set sound icon=󰕾 script="$PLUGIN_DIR/volume.sh" \
  --subscribe sound volume_change mouse.entered mouse.exited mouse.clicked \
                    mouse.scrolled
