#!/usr/bin/env bash
# AeroSpace workspace indicators.
#   space.N      mouse.clicked -> switch to workspace N
#   space_driver any other event -> repaint all workspace items atomically

source "${SKETCHYBAR_CONFIG_DIR:-$HOME/.config/sketchybar}/variables.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  aerospace workspace "${NAME#space.}" 2>/dev/null
  exit 0
fi

[ "$NAME" = "space_driver" ] || exit 0

# Query current state; the env var from the trigger can be stale.
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
[ -z "$FOCUSED" ] && exit 0
OCCUPIED=" $(aerospace list-workspaces --monitor all --empty no 2>/dev/null | tr '\n' ' ') "

args=()
for sid in 1 2 3 4 5 6 7 8 9; do
  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set "space.$sid" drawing=on background.color=$ACCENT background.drawing=on label.color=$BASE)
  elif [[ "$OCCUPIED" == *" $sid "* ]]; then
    args+=(--set "space.$sid" drawing=on background.color=$TRANSPARENT label.color=$WHITE)
  else
    args+=(--set "space.$sid" drawing=off)
  fi
done
sketchybar "${args[@]}"
