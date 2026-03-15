#!/usr/bin/env bash

# Left side: after front_app, in the empty portion of the bar.
sketchybar --add item todo left \
  --set todo script="$PLUGIN_DIR/todo.sh" \
  updates=on \
  icon="✓" \
  icon.font="$FONT:Bold:14.0" \
  icon.color="$GREEN" \
  icon.padding_left=10 \
  icon.padding_right=5 \
  label.font="$FONT:Bold:13.0" \
  label.color="$WHITE" \
  label.drawing=on \
  label.padding_left=4 \
  label.padding_right=10 \
  background.height=26 \
  background.color=0x00000000 \
  background.border_color=$COMMENT \
  background.border_width=1 \
  background.corner_radius=$CORNER_RADIUS \
  background.padding_left=12 \
  background.padding_right=10 \
  associated_display=active \
  drawing=on \
  label="—" \
  --subscribe todo todo_update mouse.clicked
