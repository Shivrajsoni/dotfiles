#!/usr/bin/env bash

# Aerospace workspaces 1–5; show space number in the bar
for sid in 1 2 3 4 5; do
  sketchybar --add space space.$sid left \
    --set space.$sid associated_space=$sid \
    icon="" \
    label="$sid" \
    label.drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    --subscribe space.$sid aerospace_workspace_change mouse.clicked
done
