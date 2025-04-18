#!/usr/bin/env bash

# Exit if NAME isn't set (required by sketchybar)
if [ -z "$NAME" ]; then
  echo "Error: NAME variable is not set."
  exit 1
fi

# Get CPU usage using top (macOS way)
CPU_USAGE=$(top -l 1 | awk -F'[:,]' '/CPU usage/ { gsub(/ /, "", $2); print $2 }')

# Fallback method using ps (less accurate on macOS, but optional)
# CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f%%", s/8}')

# Send to sketchybar
sketchybar --set "$NAME" icon="" label="$CPU_USAGE"
