#!/usr/bin/env bash
# Single todo for sketchybar. Persists in $HOME so it survives bar reload.
# Usage: todo "description" | todo -c | todo -l

TODO_FILE="${HOME}/.sketchybar_todo"

if [ -z "$1" ]; then
  echo "Usage: todo \"description\"   Set (replaces existing)"
  echo "       todo -l               Show current"
  echo "       todo -c               Clear"
  exit 1
fi

case "$1" in
  -l)
    [ -f "$TODO_FILE" ] && [ -s "$TODO_FILE" ] && cat "$TODO_FILE" || echo "No todo set"
    ;;
  -c)
    : > "$TODO_FILE"
    sketchybar --trigger todo_update
    echo "Todo cleared"
    ;;
  *)
    printf '%s\n' "$1" > "$TODO_FILE"
    sketchybar --trigger todo_update
    echo "Todo set: $1"
    ;;
esac
