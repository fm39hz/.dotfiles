#!/bin/bash
FILE="$1"
PROJECT_ROOT=$(dirname "$FILE")
while [ "$PROJECT_ROOT" != "/" ]; do
  [ -f "$PROJECT_ROOT/project.godot" ] && break
  PROJECT_ROOT=$(dirname "$PROJECT_ROOT")
done

PROJECT_NAME=$(basename "$PROJECT_ROOT" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')

# Try to send to the project's session
if zellij list-sessions -n 2>/dev/null | rg -q "^$PROJECT_NAME"; then
  zellij action write-chars $'\x1b' --session "$PROJECT_NAME"
  zellij action write-chars ":tabedit $FILE"$'\n' --session "$PROJECT_NAME"
else
  echo "No Zellij session found for project: $PROJECT_NAME"
  echo "Start one with: cd $PROJECT_ROOT && zj"
fi
