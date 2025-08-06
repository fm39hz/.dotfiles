#!/bin/bash

# Function to find project root (based on typical markers)
find_project_root() {
  local path="$1"
  while [ "$path" != "/" ]; do
    if [ -f "$path/project.godot" ] ||
      [ -d "$path/.git" ] ||
      [ -f "$path/package.json" ] ||
      [ -f "$path/Cargo.toml" ] ||
      [ -f "$path/go.mod" ]; then
      echo "$path"
      return
    fi
    path=$(dirname "$path")
  done
  echo "$1" # fallback
}

# List ALL sessions including dead ones for resurrection
list_all_sessions() {
  zellij list-sessions -n 2>/dev/null | awk '{print $1}'
}

# List only active sessions
list_active_sessions() {
  zellij list-sessions -n 2>/dev/null | grep -v "EXITED" | awk '{print $1}'
}

# Check if session is dead/exited
is_session_dead() {
  local session="$1"
  zellij list-sessions 2>/dev/null | grep "^$session" | grep -q "EXITED"
}

# Fuzzy match a session (including dead ones for resurrection)
fuzzy_match_session() {
  local query="$1"
  list_all_sessions | while read -r full; do
    stripped="${full#proj-}"
    if [[ "${stripped,,}" == *"${query,,}"* ]]; then
      echo "$full"
      return 0
    fi
  done
}

# FZF with status indicators
fzf_select_session_with_status() {
  zellij list-sessions 2>/dev/null | while read -r line; do
    session=$(echo "$line" | awk '{print $1}')
    if echo "$line" | grep -q "EXITED"; then
      echo "󰚛  $session (dead - will resurrect)"
    else
      echo "  $session (active)"
    fi
  done | fzf --prompt="󰋼 Pick a session: " --height=40% --reverse --ansi | awk '{print $2}'
}

# Smart attach with resurrection support
smart_attach() {
  local session_name="$1"

  if is_session_dead "$session_name"; then
    echo "󰚛  Session '$session_name' is dead. Resurrecting..."
    # Force attach to resurrect dead session
    if zellij attach --force "$session_name" 2>/dev/null; then
      echo " Successfully resurrected '$session_name'!"
    else
      echo " Resurrection failed, creating new session..."
      zellij attach -c "$session_name"
    fi
  else
    # Check if session exists at all
    if list_all_sessions | grep -q "^$session_name$"; then
      echo " Attaching to active session: $session_name"
      zellij attach "$session_name"
    else
      echo " Creating new session: $session_name"
      zellij attach -c "$session_name"
    fi
  fi
}

# List all sessions with status
show_all_sessions() {
  echo "󰈙 All Zellij sessions:"
  zellij list-sessions 2>/dev/null | while read -r line; do
    session=$(echo "$line" | awk '{print $1}')
    if echo "$line" | grep -q "EXITED"; then
      created=$(echo "$line" | grep -o '\[.*\]')
      echo "󰚛 $session $created (can be resurrected)"
    else
      created=$(echo "$line" | grep -o '\[.*\]')
      echo " $session $created"
    fi
  done
}

# ========== MAIN ==========

# Special commands
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  show_all_sessions
  exit 0
fi

if [ "$1" = "--kill-all-dead" ]; then
  echo "󰃢 Cleaning up dead sessions..."
  list_all_sessions | while read -r session; do
    if is_session_dead "$session"; then
      echo " Killing $session"
      zellij kill-session "$session" 2>/dev/null
    fi
  done
  echo "  Cleanup complete!"
  exit 0
fi

# Check if a name was passed
QUERY="$1"

if [ -n "$QUERY" ]; then
  # First try exact match with proj- prefix
  EXACT="proj-$(echo "$QUERY" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')"
  if list_all_sessions | grep -q "^$EXACT$"; then
    MATCHED="$EXACT"
  else
    # Try fuzzy match
    MATCHED=$(fuzzy_match_session "$QUERY")
  fi

  if [ -n "$MATCHED" ]; then
    smart_attach "$MATCHED"
    exit $?
  else
    echo " No matching session found for '$QUERY'"
    echo ""
    echo "󰈙 Available sessions (󰚛  = dead,   = active):"
    ALT=$(fzf_select_session_with_status)
    if [ -n "$ALT" ]; then
      smart_attach "$ALT"
      exit $?
    else
      echo "  No session selected. Exiting."
      exit 1
    fi
  fi
fi

# If no query was passed, auto-detect and create if not exists
PROJECT_ROOT=$(find_project_root "$(pwd)")
PROJECT_NAME=$(basename "$PROJECT_ROOT" | sed 's/^\.//')
SESSION_NAME="proj-$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')"

# Check if session exists (dead or alive)
if list_all_sessions | grep -q "^$SESSION_NAME$"; then
  if is_session_dead "$SESSION_NAME"; then
    echo "  Found dead project session: $SESSION_NAME"
    echo "  Resurrecting in $PROJECT_ROOT..."
  else
    echo " Found active project session: $SESSION_NAME"
  fi
else
  echo " Creating new project session: $SESSION_NAME"
  echo " Location: $PROJECT_ROOT"
fi

cd "$PROJECT_ROOT" 2>/dev/null || {
  echo "  Cannot enter $PROJECT_ROOT"
  exit 1
}

smart_attach "$SESSION_NAME"
