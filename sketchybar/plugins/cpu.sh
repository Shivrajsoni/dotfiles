##!/usr/bin/env bash

# Check if the NAME variable is set
#if [ -z "$NAME" ]; then
# echo "Error: NAME variable is not set."
# exit 1
#fi

# Calculate CPU usage
#CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {s /= 8} END {printf "%.1f%%\n", s}')

#!/bin/bash
top -l 1 | awk '/CPU usage/ {print $3}'
# Update the sketchybar item with the calculated CPU usage
#sketchybar --set "$NAME" icon="" label="$CPU_USAGE"
