#!/usr/bin/env bash

# Exit if NAME isn't set (required by sketchybar)
if [ -z "$NAME" ]; then
  echo "Error: NAME variable is not set."
  exit 1
fi

# Get CPU usage
CPU_PERCENTAGE=$(top -l 1 | awk -F'[ ,%]+' '/CPU usage/ {print int($3 + $5)}')

# Send to sketchybar
sketchybar --set "$NAME" label="${CPU_PERCENTAGE}%"
