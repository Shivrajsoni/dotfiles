#!/usr/bin/env bash

# Exit if NAME isn't set (required by sketchybar)
if [ -z "$NAME" ]; then
  echo "Error: NAME variable is not set."
  exit 1
fi

# Get CPU usage efficiently using ps
CORES=$(sysctl -n hw.logicalcpu)
CPU_PERCENTAGE=$(ps -A -o %cpu | awk -v cores="$CORES" '{s+=$1} END {printf "%d\n", s/cores}')

# Send to sketchybar
sketchybar --set "$NAME" label="${CPU_PERCENTAGE}%"
