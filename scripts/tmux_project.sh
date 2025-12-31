#!/bin/bash

TMUXP_CONFIG_DIR="$HOME/.config/tmuxp"
mkdir -p "$TMUXP_CONFIG_DIR"

find_project_root() {
  local path="$1"
  while [ "$path" != "/" ]; do
    if [ -f "$path/project.godot" ] || [ -d "$path/.git" ] || [ -f "$path/package.json" ] || [ -f "$path/Cargo.toml" ] || [ -f "$path/go.mod" ]; then
      echo "$path"
      return
    fi
    path=$(dirname "$path")
  done
  echo "$1"
}

detect_project_type() {
  local path="${1:-$(pwd)}"
  [ -f "$path/project.godot" ] && {
    echo "godot"
    return
  }
  [ -f "$path/ProjectSettings/ProjectVersion.txt" ] && {
    echo "unity"
    return
  }
  [ -f "$path/pubspec.yaml" ] && {
    echo "flutter"
    return
  }
  [ -f "$path/package.json" ] && {
    echo "node"
    return
  }
  [ -f "$path/Cargo.toml" ] && {
    echo "rust"
    return
  }
  [ -f "$path/go.mod" ] && {
    echo "go"
    return
  }

  if [[ "$(basename "$path")" =~ ^\..*config.*|dotfiles?$ ]] || [ -d "$path/.config" ]; then
    echo "dotfiles"
    return
  fi
}

generate_session_name() {
  local project_root="$1"
  local project_type=${2:-$(detect_project_type "$project_root")}
  local project_name="${project_root##*/}"
  project_name="${project_name#.}"

  local base_name
  base_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')
  [ -n "$project_type" ] && echo "$project_type-$base_name" || echo "$base_name"
}

list_available_tmuxp_presets() {
  local active_sessions
  active_sessions=$(tmux ls -F "#{session_name}" 2>/dev/null)

  if [ -d "$TMUXP_CONFIG_DIR" ]; then
    fd -e json . "$TMUXP_CONFIG_DIR" --exec-batch basename -s .json |
      rg -vFxf <(echo "$active_sessions") | sed 's/^/󱔐 [Preset] /'
  fi
}

smart_attach() {
  local target="$1"
  local project_root="$2"
  local final_session_name="${target#*] }"

  if ! tmux has-session -t "$final_session_name" 2>/dev/null; then
    if [ -f "$TMUXP_CONFIG_DIR/${final_session_name}.json" ]; then
      echo " 󱔐 Baking layout: $final_session_name"
      tmuxp load -d -y "$final_session_name" >/dev/null 2>&1
    else
      echo " 󰙴 Creating session: $final_session_name"
      tmux new-session -d -s "$final_session_name" -c "${project_root:-$(pwd)}"
    fi
  fi

  [ -n "$TMUX" ] && tmux switch-client -t "$final_session_name" || tmux attach-session -t "$final_session_name"
}

fzf_select_session() {
  local current_project="$1"
  local selection

  selection=$({
    echo "󰐕 [Create new session: $current_project]"
    list_available_tmuxp_presets
    tmux ls -F "󰈙 [Active] #{session_name}: #{session_windows} windows" 2>/dev/null
  } | fzf --prompt="󰋼 Session: " --height=40% --reverse --ansi)

  [ $? -ne 0 ] && return 1

  if [[ "$selection" == "󰐕 [Create new session:"* ]]; then
    return 2
  elif [[ "$selection" == "󱔐 [Preset] "* ]]; then
    echo "$selection"
    return 0
  else
    echo "$selection" | rg -o '\[Active\] ([^:]+)' -r '$1'
    return 0
  fi
}

case "$1" in
--kill-all)
  tmux ls -F "#{session_name}" 2>/dev/null | xargs -I{} tmux kill-session -t "{}"
  exit 0
  ;;
--list | -l)
  tmux ls 2>/dev/null
  exit 0
  ;;
esac

PROJECT_ROOT=$(find_project_root "$(pwd)")
SESSION_NAME=$(generate_session_name "$PROJECT_ROOT")

if [ -n "$1" ]; then
  smart_attach "$1" "$PROJECT_ROOT"
  exit 0
fi

SELECTED=$(fzf_select_session "$SESSION_NAME")
RET=$?
if [ $RET -eq 2 ]; then
  smart_attach "$SESSION_NAME" "$PROJECT_ROOT"
elif [ $RET -eq 0 ]; then
  smart_attach "$SELECTED" "$PROJECT_ROOT"
fi
