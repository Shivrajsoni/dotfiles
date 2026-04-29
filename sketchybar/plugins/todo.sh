#!/usr/bin/env bash
# Single todo: read from a fixed path so it survives reload (no CONFIG_DIR/env dependency).
[ -z "$NAME" ] && exit 1

HOME="${HOME:-$(eval echo ~$(id -un))}"
TODO_FILE="$HOME/.sketchybar_todo"
MAX_LEN=40

if [ -f "$TODO_FILE" ] && [ -s "$TODO_FILE" ]; then
  description=$(head -n1 "$TODO_FILE")
  [ ${#description} -gt $MAX_LEN ] && description="${description:0:$((MAX_LEN-3))}..."
  sketchybar --set "$NAME" label="1  $description" label.drawing=on drawing=on
else
  sketchybar --set "$NAME" label="0  —" label.drawing=on drawing=on
fi
