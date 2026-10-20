#!/usr/bin/env bash

# AeroSpace workspaces as plain items (not macOS `space` items: AeroSpace
# workspaces are independent of native spaces). Empty, unfocused workspaces
# are hidden by the driver below.
for sid in 1 2 3 4 5 6 7 8 9; do
  sketchybar --add item space.$sid left \
    --set space.$sid \
    icon.drawing=off \
    label="$sid" \
    label.font="$FONT:Bold:12.0" \
    label.padding_left=8 \
    label.padding_right=8 \
    background.color=$TRANSPARENT \
    background.border_width=0 \
    background.padding_left=0 \
    background.padding_right=0 \
    drawing=off \
    script="$PLUGIN_DIR/space.sh" \
    --subscribe space.$sid mouse.clicked
done

# One pill behind all workspace items
sketchybar --add bracket spaces '/space\..*/' \
  --set spaces background.color=$SURFACE0 \
               background.border_color=$SURFACE1 \
               background.border_width=$BORDER_WIDTH

# Hidden driver: repaints every workspace item in one atomic call. Also ticks
# periodically and on app switches so new/closed windows are picked up.
sketchybar --add item space_driver left \
  --set space_driver drawing=off updates=on update_freq=5 \
        script="$PLUGIN_DIR/space.sh" \
  --subscribe space_driver aerospace_workspace_change front_app_switched system_woke
