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
# Usage: bind with tmx
#   tmx                   # Show session picker (blank = create new for current dir)
#   tmx myapp             # Find/create session matching "myapp"
#   tmx --list            # List all sessions
#   tmx --kill-all        # Kill all sessions

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
  [ -f "$path/project.godot" ] && {
    echo "godot"
    return
  }
  [ -f "$path/ProjectSettings/ProjectVersion.txt" ] && {
    echo "unity"
    return
  }

  # Mobile Development
  [ -f "$path/pubspec.yaml" ] && {
    echo "flutter"
    return
  }
  [ -f "$path/ios/Podfile" ] && [ -f "$path/android/build.gradle" ] && {
    echo "reactnative"
    return
  }

  # .NET Family
  shopt -s nullglob
  local csprojs=("$path"/*.csproj)
  local slns=("$path"/*.sln)
  shopt -u nullglob
  if [ ${#csprojs[@]} -gt 0 ] || [ ${#slns[@]} -gt 0 ]; then
    echo "dotnet" && return
  fi
  [ -f "$path/project.json" ] && [[ $(<"$path/project.json") == *"Microsoft"* ]] && {
    echo "dotnet"
    return
  }

  # Web Frameworks (check package.json content for specifics)
  if [ -f "$path/package.json" ]; then
    local pkg_content
    pkg_content=$(<"$path/package.json")
    case "$pkg_content" in
    *'"next"'*)
      echo "nextjs"
      return
      ;;
    *'"react"'*'"@types/react"'* | *'"@types/react"'*'"react"'*)
      echo "react"
      return
      ;;
    *'"vue"'*)
      echo "vue"
      return
      ;;
    *'"@angular"'*)
      echo "angular"
      return
      ;;
    *'"svelte"'*)
      echo "svelte"
      return
      ;;
    *'"electron"'*)
      echo "electron"
      return
      ;;
    *)
      echo "node"
      return
      ;;
    esac
  fi

  # Languages
  [ -f "$path/Cargo.toml" ] && {
    echo "rust"
    return
  }
  [ -f "$path/go.mod" ] && {
    echo "go"
    return
  }

  # Python (check for specific frameworks)
  local py_req_files=()
  [ -f "$path/pyproject.toml" ] && py_req_files+=("$path/pyproject.toml")
  [ -f "$path/requirements.txt" ] && py_req_files+=("$path/requirements.txt")

  if [ ${#py_req_files[@]} -gt 0 ] || [ -f "$path/setup.py" ]; then
    if [ -f "$path/manage.py" ] || ([ ${#py_req_files[@]} -gt 0 ] && rg -q "django" "${py_req_files[@]}" 2>/dev/null); then
      echo "django" && return
    elif ([ ${#py_req_files[@]} -gt 0 ] && rg -q "flask" "${py_req_files[@]}" 2>/dev/null); then
      echo "flask" && return
    elif ([ ${#py_req_files[@]} -gt 0 ] && rg -q "fastapi" "${py_req_files[@]}" 2>/dev/null); then
      echo "fastapi" && return
    else
      echo "python" && return
    fi
  fi

  # Other Languages
  [ -f "$path/composer.json" ] && {
    echo "php"
    return
  }
  [ -f "$path/Gemfile" ] && {
    echo "ruby"
    return
  }
  [ -f "$path/pom.xml" ] && {
    echo "maven"
    return
  }
  [ -f "$path/build.gradle" ] || [ -f "$path/build.gradle.kts" ] && {
    echo "gradle"
    return
  }

  # Build Systems
  [ -f "$path/CMakeLists.txt" ] && {
    echo "cmake"
    return
  }
  [ -f "$path/Makefile" ] && {
    echo "make"
    return
  }

  # Configuration/Dotfiles
  if [[ "$(basename "$path")" =~ ^\..*config.*|dotfiles?$ ]] || [ -d "$path/.config" ]; then
    echo "dotfiles" && return
  fi

  # Infrastructure
  [ -f "$path/docker-compose.yml" ] || [ -f "$path/docker-compose.yaml" ] && {
    echo "docker"
    return
  }
  [ -f "$path/Dockerfile" ] && {
    echo "docker"
    return
  }
  [ -f "$path/terraform.tf" ] || [ -f "$path/main.tf" ] && {
    echo "terraform"
    return
  }
  [ -f "$path/ansible.cfg" ] || [ -d "$path/playbooks" ] && {
    echo "ansible"
    return
  }

  # Documentation
  [ -f "$path/mkdocs.yml" ] && {
    echo "docs"
    return
  }
  [ -f "$path/Gemfile" ] && rg -q "jekyll" "$path/Gemfile" && {
    echo "jekyll"
    return
  }

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
  # The second argument is an optional project_type to avoid re-detection.
  local project_type=${2:-$(detect_project_type "$project_root")}
  local project_name
  project_name=$(basename "$project_root" | sed 's/^\.//')
  local base_name
  base_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')

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

# FZF session selector with option to create new
# Returns: exit code 0 with selection, 1 if cancelled, 2 if create new requested
fzf_select_session() {
  local current_project="$1"
  local prompt_text="󰋼 Pick a session (Enter = new session for current dir): "

  # Add a special entry for creating new session
  local selection
  selection=$({
    echo "󰐕 [Create new session: $current_project]"
    tmux ls -F "#{session_name}: #{session_windows} windows (created #{session_created_string})" 2>/dev/null
  } | fzf --prompt="$prompt_text" --height=40% --reverse --ansi --header="Press Enter on blank or first item to create new session")

  local fzf_exit=$?

  # Check fzf exit code
  if [ $fzf_exit -ne 0 ]; then
    # User cancelled (Ctrl-C, Esc, etc)
    return 1
  fi

  if [[ "$selection" == "󰐕 [Create new session:"* ]]; then
    # User wants to create new session
    return 2
  elif [ -n "$selection" ]; then
    # User selected an existing session
    echo "$selection" | cut -d: -f1
    return 0
  else
    # Empty selection shouldn't happen with proper fzf, but treat as cancel
    return 1
  fi
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
    ALT=$(fzf_select_session "")
    ALT_EXIT=$?

    if [ $ALT_EXIT -eq 1 ]; then
      # User cancelled
      echo "  Cancelled."
      exit 0
    elif [ $ALT_EXIT -eq 2 ]; then
      # User wants to create new
      echo "  Creating new session..."
      smart_attach "$EXACT" "$CURRENT_ROOT"
      exit $?
    elif [ -n "$ALT" ]; then
      # User selected existing session
      smart_attach "$ALT"
      exit $?
    else
      # Shouldn't happen, but treat as cancel
      echo "  Cancelled."
      exit 0
    fi
  fi
fi

# If no query was passed, show session picker with option to create new
PROJECT_ROOT=$(find_project_root "$(pwd)")
PROJECT_TYPE=$(detect_project_type "$PROJECT_ROOT")
SESSION_NAME=$(generate_session_name "$PROJECT_ROOT" "$PROJECT_TYPE")

# Show session picker
SELECTED=$(fzf_select_session "$SESSION_NAME")
SELECT_EXIT=$?

# Handle fzf result
if [ $SELECT_EXIT -eq 1 ]; then
  # User cancelled (Ctrl-C, Esc, etc)
  echo "  Cancelled."
  exit 0
elif [ $SELECT_EXIT -eq 2 ]; then
  # User wants to create new session
  if [ -n "$PROJECT_TYPE" ]; then
    echo " Creating new project session: $SESSION_NAME"
  else
    echo "󰙴 Creating new session: $SESSION_NAME"
  fi
  echo " Location: $PROJECT_ROOT"

  cd "$PROJECT_ROOT" 2>/dev/null || {
    echo "  Cannot enter $PROJECT_ROOT"
    exit 1
  }

  smart_attach "$SESSION_NAME" "$PROJECT_ROOT"
elif [ -n "$SELECTED" ]; then
  # User selected an existing session
  smart_attach "$SELECTED"
else
  # Shouldn't happen, but treat as cancel
  echo "  Cancelled."
  exit 0
fi
