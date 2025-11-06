#!/bin/bash

# Smart Zellij Session Manager with Project Type Detection
#
# Session naming examples:
#   godot-projectmundus    (Godot game project)
#   dotnet-timmerapp      (.NET application)
#   react-dashboard       (React web app)
#   rust-mylib           (Rust library)
#   dotfiles-config      (Configuration files)
#   documents            (Regular directory - no prefix)
#
# Usage: bind with tmz
#   tmz                   # Auto-detect current directory
#   tmz myapp             # Find/create session matching "myapp"
#   tmz --list            # List all sessions with status
#   tmz --kill-all-dead   # Clean up dead sessions

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

# Detect specific project type and return appropriate prefix
detect_project_type() {
  local path="${1:-$(pwd)}"

  # Specific project type detection (order matters - most specific first)

  # Game Development
  [ -f "$path/project.godot" ] && echo "godot" && return
  [ -f "$path/ProjectSettings/ProjectVersion.txt" ] && echo "unity" && return

  # Mobile Development
  [ -f "$path/pubspec.yaml" ] && echo "flutter" && return
  [ -f "$path/ios/Podfile" ] && [ -f "$path/android/build.gradle" ] && echo "reactnative" && return

  # .NET Family
  if ls "$path"/*.csproj >/dev/null 2>&1 || ls "$path"/*.sln >/dev/null 2>&1; then
    echo "dotnet" && return
  fi
  [ -f "$path/project.json" ] && rg -q "Microsoft" "$path/project.json" && echo "dotnet" && return

  # Web Frameworks (check package.json content for specifics)
  if [ -f "$path/package.json" ]; then
    if rg -q '"next"' "$path/package.json"; then
      echo "nextjs" && return
    elif rg -q '"react"' "$path/package.json" && rg -q '"@types/react"' "$path/package.json"; then
      echo "react" && return
    elif rg -q '"vue"' "$path/package.json"; then
      echo "vue" && return
    elif rg -q '"@angular"' "$path/package.json"; then
      echo "angular" && return
    elif rg -q '"svelte"' "$path/package.json"; then
      echo "svelte" && return
    elif rg -q '"electron"' "$path/package.json"; then
      echo "electron" && return
    else
      echo "node" && return
    fi
  fi

  # Languages
  [ -f "$path/Cargo.toml" ] && echo "rust" && return
  [ -f "$path/go.mod" ] && echo "go" && return

  # Python (check for specific frameworks)
  if [ -f "$path/pyproject.toml" ] || [ -f "$path/requirements.txt" ] || [ -f "$path/setup.py" ]; then
    if [ -f "$path/manage.py" ] || rg -q "django" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
      echo "django" && return
    elif rg -q "flask" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
      echo "flask" && return
    elif rg -q "fastapi" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
      echo "fastapi" && return
    else
      echo "python" && return
    fi
  fi

  # Other Languages
  [ -f "$path/composer.json" ] && echo "php" && return
  [ -f "$path/Gemfile" ] && echo "ruby" && return
  [ -f "$path/pom.xml" ] && echo "maven" && return
  [ -f "$path/build.gradle" ] || [ -f "$path/build.gradle.kts" ] && echo "gradle" && return

  # Build Systems
  [ -f "$path/CMakeLists.txt" ] && echo "cmake" && return
  [ -f "$path/Makefile" ] && echo "make" && return

  # Configuration/Dotfiles
  if [[ "$(basename "$path")" =~ ^\..*config.*|dotfiles?$ ]] || [ -d "$path/.config" ]; then
    echo "dotfiles" && return
  fi

  # Infrastructure
  [ -f "$path/docker-compose.yml" ] || [ -f "$path/docker-compose.yaml" ] && echo "docker" && return
  [ -f "$path/Dockerfile" ] && echo "docker" && return
  [ -f "$path/terraform.tf" ] || [ -f "$path/main.tf" ] && echo "terraform" && return
  [ -f "$path/ansible.cfg" ] || [ -d "$path/playbooks" ] && echo "ansible" && return

  # Documentation
  [ -f "$path/mkdocs.yml" ] && echo "docs" && return
  [ -f "$path/Gemfile" ] && rg -q "jekyll" "$path/Gemfile" && echo "jekyll" && return

  # Generic project detection (fallback)
  if git -C "$path" rev-parse --git-dir >/dev/null 2>&1 ||
    [ -d "$path/src" ] || [ -d "$path/lib" ] ||
    [ -d "$path/.vscode" ] || [ -d "$path/.idea" ]; then
    echo "project"
    return
  fi

  # Not a project
  echo ""
}

# Generate session name with smart project-type prefix
generate_session_name() {
  local project_root="$1"
  local project_name
  project_name=$(basename "$project_root" | sed 's/^\.//')
  local base_name
  base_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')
  local project_type
  project_type=$(detect_project_type "$project_root")

  if [ -n "$project_type" ]; then
    echo "$project_type-$base_name"
  else
    echo "$base_name"
  fi
}

# List ALL sessions including dead ones for resurrection
list_all_sessions() {
  zellij ls --no-formatting 2>/dev/null | awk '{print $1}'
}

# List only active sessions
list_active_sessions() {
  zellij ls --no-formatting 2>/dev/null | rg -v "EXITED" | awk '{print $1}'
}

# Check if session is dead/exited
is_session_dead() {
  local session="$1"
  zellij ls --no-formatting 2>/dev/null | rg "^$session" | rg -q "EXITED"
}

# Fuzzy match a session (including dead ones for resurrection)
fuzzy_match_session() {
  local query="$1"
  list_all_sessions | while read -r full; do
    # Try matching with any project-type prefix removed
    stripped="${full#*-}" # Remove everything up to first dash
    if [[ "${stripped,,}" == *"${query,,}"* ]]; then
      echo "$full"
      return 0
    fi
    # Also try exact match
    if [[ "${full,,}" == *"${query,,}"* ]]; then
      echo "$full"
      return 0
    fi
  done
}

# FZF with status indicators
fzf_select_session_with_status() {
  zellij ls --no-formatting 2>/dev/null | while read -r line; do
    session=$(echo "$line" | awk '{print $1}')
    if echo "$line" | rg -q "EXITED"; then
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
      echo "󰙴 Successfully resurrected '$session_name'!"
    else
      echo " Resurrection failed, creating new session..."
      zellij attach -c "$session_name"
    fi
  else
    # Check if session exists at all
    if list_all_sessions | rg -q "^$session_name$"; then
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
  zellij ls --no-formatting 2>/dev/null | while read -r line; do
    session=$(echo "$line" | awk '{print $1}')
    if echo "$line" | rg -q "EXITED"; then
      created=$(echo "$line" | rg -o '\[.*\]')
      echo "󰚛 $session $created (can be resurrected)"
    else
      created=$(echo "$line" | rg -o '\[.*\]')
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
  echo "󰙴 Cleanup complete!"
  exit 0
fi

# Check if a name was passed
QUERY="$1"

if [ -n "$QUERY" ]; then
  # Smart session name generation for query
  CURRENT_ROOT=$(find_project_root "$(pwd)")
  BASE_QUERY=$(echo "$QUERY" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')

  # Try exact match with smart naming
  PROJECT_TYPE=$(detect_project_type "$CURRENT_ROOT")
  if [ -n "$PROJECT_TYPE" ]; then
    EXACT="$PROJECT_TYPE-$BASE_QUERY"
  else
    EXACT="$BASE_QUERY"
  fi

  if list_all_sessions | rg -q "^$EXACT$"; then
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
    echo "󰈙 Available sessions (󰚛  = dead,   = active):"
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
SESSION_NAME=$(generate_session_name "$PROJECT_ROOT")
PROJECT_TYPE=$(detect_project_type "$PROJECT_ROOT")

# Check if session exists (dead or alive)
if list_all_sessions | rg -q "^$SESSION_NAME$"; then
  if is_session_dead "$SESSION_NAME"; then
    echo "  Found dead project session: $SESSION_NAME"
    echo "󰙴  Resurrecting in $PROJECT_ROOT..."
  else
    echo " Found active project session: $SESSION_NAME"
  fi
else
  if [ -n "$PROJECT_TYPE" ]; then
    echo " Creating new project session: $SESSION_NAME"
  else
    echo "󰙴 Creating new session: $SESSION_NAME"
  fi
  echo " Location: $PROJECT_ROOT"
fi

cd "$PROJECT_ROOT" 2>/dev/null || {
  echo "  Cannot enter $PROJECT_ROOT"
  exit 1
}

smart_attach "$SESSION_NAME"
