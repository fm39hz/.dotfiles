#!/bin/bash

# Smart Tmux Session Manager with Project Type Detection
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
#   tmz --list            # List all sessions
#   tmz --kill-all        # Kill all sessions

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
  [ -f "$path/project.json" ] && grep -q "Microsoft" "$path/project.json" && echo "dotnet" && return

  # Web Frameworks (check package.json content for specifics)
  if [ -f "$path/package.json" ]; then
    if grep -q '"next"' "$path/package.json"; then
      echo "nextjs" && return
    elif grep -q '"react"' "$path/package.json" && grep -q '"@types/react"' "$path/package.json"; then
      echo "react" && return
    elif grep -q '"vue"' "$path/package.json"; then
      echo "vue" && return
    elif grep -q '"@angular"' "$path/package.json"; then
      echo "angular" && return
    elif grep -q '"svelte"' "$path/package.json"; then
      echo "svelte" && return
    elif grep -q '"electron"' "$path/package.json"; then
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
    if [ -f "$path/manage.py" ] || grep -q "django" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
      echo "django" && return
    elif grep -q "flask" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
      echo "flask" && return
    elif grep -q "fastapi" "$path/requirements.txt" "$path/pyproject.toml" 2>/dev/null; then
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
  [ -f "$path/Gemfile" ] && grep -q "jekyll" "$path/Gemfile" && echo "jekyll" && return

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

# List all sessions
list_all_sessions() {
  tmux ls -F "#{session_name}" 2>/dev/null
}

# Check if session exists
session_exists() {
  local session="$1"
  tmux has-session -t "$session" 2>/dev/null
}

# Fuzzy match a session
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

# FZF session selector
fzf_select_session() {
  tmux ls -F "#{session_name}: #{session_windows} windows (created #{session_created_string})" 2>/dev/null |
    fzf --prompt="󰋼 Pick a session: " --height=40% --reverse --ansi |
    cut -d: -f1
}

# Smart attach/switch
smart_attach() {
  local session_name="$1"
  local project_root="$2"

  if session_exists "$session_name"; then
    # Session exists
    if [ -n "$TMUX" ]; then
      # Already inside tmux, switch to session
      echo " Switching to session: $session_name"
      tmux switch-client -t "$session_name"
    else
      # Outside tmux, attach to session
      echo " Attaching to session: $session_name"
      tmux attach-session -t "$session_name"
    fi
  else
    # Session doesn't exist, create it
    echo " Creating new session: $session_name"
    if [ -n "$project_root" ]; then
      echo " Location: $project_root"
    fi

    if [ -n "$TMUX" ]; then
      # Inside tmux, create and switch
      tmux new-session -d -s "$session_name" -c "${project_root:-$(pwd)}"
      tmux switch-client -t "$session_name"
    else
      # Outside tmux, create and attach
      tmux new-session -s "$session_name" -c "${project_root:-$(pwd)}"
    fi
  fi
}

# List all sessions with details
show_all_sessions() {
  echo "󰈙 All tmux sessions:"
  if ! tmux ls 2>/dev/null; then
    echo "  No active sessions"
  fi
}

# Kill all sessions
kill_all_sessions() {
  echo "󰃢 Killing all tmux sessions..."
  local sessions
  sessions=$(list_all_sessions)
  if [ -z "$sessions" ]; then
    echo "  No sessions to kill"
    exit 0
  fi

  while read -r session; do
    echo " Killing $session"
    tmux kill-session -t "$session" 2>/dev/null
  done <<<"$sessions"
  echo "󰙴 All sessions killed!"
}

# ========== MAIN ==========

# Special commands
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  show_all_sessions
  exit 0
fi

if [ "$1" = "--kill-all" ]; then
  kill_all_sessions
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

  if session_exists "$EXACT"; then
    MATCHED="$EXACT"
  else
    # Try fuzzy match
    MATCHED=$(fuzzy_match_session "$QUERY")
  fi

  if [ -n "$MATCHED" ]; then
    smart_attach "$MATCHED"
    exit $?
  else
    echo " No matching session found for '$QUERY'"
    echo ""
    echo "󰈙 Available sessions:"
    ALT=$(fzf_select_session)
    if [ -n "$ALT" ]; then
      smart_attach "$ALT"
      exit $?
    else
      echo "  No session selected. Creating new session..."
      smart_attach "$EXACT" "$CURRENT_ROOT"
      exit $?
    fi
  fi
fi

# If no query was passed, auto-detect and create if not exists
PROJECT_ROOT=$(find_project_root "$(pwd)")
SESSION_NAME=$(generate_session_name "$PROJECT_ROOT")
PROJECT_TYPE=$(detect_project_type "$PROJECT_ROOT")

# Check if session exists
if session_exists "$SESSION_NAME"; then
  echo " Found existing project session: $SESSION_NAME"
else
  if [ -n "$PROJECT_TYPE" ]; then
    echo " Creating new project session: $SESSION_NAME"
  else
    echo "󰙴 Creating new session: $SESSION_NAME"
  fi
  echo " Location: $PROJECT_ROOT"
fi

cd "$PROJECT_ROOT" 2>/dev/null || {
  echo "  Cannot enter $PROJECT_ROOT"
  exit 1
}

smart_attach "$SESSION_NAME" "$PROJECT_ROOT"
