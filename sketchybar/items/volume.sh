#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar \
  --add item sound right \
  --set sound \
  icon=󰕾 \
  icon.color="$COLOR" \
  label.color="$COLOR" \
  script="$PLUGIN_DIR/volume.sh" \
  --subscribe sound volume_change \
                    mouse.entered \
                    mouse.exited \
                    mouse.scrolled.up \
                    mouse.scrolled.down
