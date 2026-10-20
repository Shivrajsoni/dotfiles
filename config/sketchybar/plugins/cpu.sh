#!/usr/bin/env bash

source "${SKETCHYBAR_CONFIG_DIR:-$HOME/.config/sketchybar}/variables.sh"

# Real utilization (user + sys) over a 1s window, same counters Activity
# Monitor uses. iostat's first sample is a since-boot average, so take the
# second; unlike `top` it costs ~0 CPU itself.
CPU=$(iostat -C -c 2 -w 1 | awk 'END {print $4 + $5}')

COLOR=$WHITE
[ "$CPU" -ge 60 ] && COLOR=$YELLOW
[ "$CPU" -ge 80 ] && COLOR=$RED

sketchybar --set "$NAME" label="${CPU}%" icon.color="$COLOR"
