#!/usr/bin/env bash

# Aerospace workspaces 1–5; show space number in the bar
for sid in 1 2 3 4 5; do
  sketchybar --add space space.$sid left \
    --set space.$sid associated_space=$sid \
    icon="" \
    icon.padding_left=8 \
    icon.padding_right=4 \
    label="$sid" \
    label.drawing=on \
    label.font="$FONT:Bold:13.0" \
    label.color="$WHITE" \
    label.padding_left=4 \
    label.padding_right=8 \
    background.color=0x00000000 \
    background.border_color=$COMMENT \
    background.border_width=1 \
    background.corner_radius=$CORNER_RADIUS \
    background.height=26 \
    script="$PLUGIN_DIR/space.sh" \
    --subscribe space.$sid aerospace_workspace_change mouse.clicked
done
