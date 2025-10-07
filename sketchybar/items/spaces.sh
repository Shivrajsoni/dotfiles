#!/usr/bin/env bash

SPACE_ICONS=("1" "2" "3" "4" "5")

for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i + 1))
  sketchybar --add space space.$sid left \
             --set space.$sid associated_space=$sid \
                              icon=${SPACE_ICONS[i]} \
                              icon.padding_left=10 \
                              icon.padding_right=10 \
                              background.color=0x00000000 \
                              background.border_color=$COMMENT \
                              background.border_width=1 \
                              background.corner_radius=$CORNER_RADIUS \
                              background.height=26 \
                              label.drawing=off \
                              script="$PLUGIN_DIR/space.sh" \
             --subscribe space.$sid aerospace_workspace_change mouse.clicked
done
