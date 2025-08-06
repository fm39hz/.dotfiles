#!/bin/bash

FILE="$1"

# Find the project root from the file being opened (looking for project.godot)
find_project_root() {
  local path="$1"
  while [ "$path" != "/" ]; do
    if [ -f "$path/project.godot" ]; then
      echo "$path"
      return
    fi
    path=$(dirname "$path")
  done
  return 1
}

PROJECT_ROOT=$(find_project_root "$(dirname "$FILE")")

if [ -z "$PROJECT_ROOT" ]; then
  echo "Could not find project root (no project.godot found)"
  exit 1
fi

# Find tmux pane that has nvim AND is in the project directory
NVIM_PANE=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{pane_current_path}' |
  grep -E '(nvim|neovim)' |
  grep "$PROJECT_ROOT" |
  head -1 |
  cut -d' ' -f1)

if [ -n "$NVIM_PANE" ]; then
  # Found nvim in the project directory, open file there
  tmux send-keys -t "$NVIM_PANE" Escape ":tabedit $FILE" Enter
else
  # No nvim found in project dir, look for any shell in project dir and start nvim
  SHELL_PANE=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_path}' |
    grep "$PROJECT_ROOT" |
    head -1 |
    cut -d' ' -f1)

  if [ -n "$SHELL_PANE" ]; then
    # Start nvim in the existing project pane
    tmux send-keys -t "$SHELL_PANE" "nvim $FILE" Enter
  else
    # Create new window in project directory
    tmux new-window -c "$PROJECT_ROOT" -n "godot-edit" "nvim $FILE"
  fi
fi
