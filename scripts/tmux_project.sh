#!/bin/bash

# ==============================================================================
# Smart Tmux Session Manager (Tmuxp JSON Edition - Final)
# ==============================================================================

TMUXP_CONFIG_DIR="$HOME/.config/tmuxp"
mkdir -p "$TMUXP_CONFIG_DIR"

# --- 1. HÀM NHẬN DIỆN PROJECT ---
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
  echo ""
}

generate_session_name() {
  local project_root="$1"
  local project_type=${2:-$(detect_project_type "$project_root")}
  local project_name=$(basename "$project_root" | sed 's/^\.//')
  local base_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' .' '-')
  [ -n "$project_type" ] && echo "$project_type-$base_name" || echo "$base_name"
}

# --- 2. HÀM QUẢN LÝ SESSION ---
list_all_sessions() {
  tmux ls -F "#{session_name}" 2>/dev/null
}

session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

list_available_tmuxp_presets() {
  local active_sessions=$(list_all_sessions)
  if [ -d "$TMUXP_CONFIG_DIR" ]; then
    # Chỉ quét các file .json
    for file in "$TMUXP_CONFIG_DIR"/*.json; do
      [ -e "$file" ] || continue
      local name=$(basename "$file")
      name="${name%.*}"
      if ! echo "$active_sessions" | grep -qxw "$name"; then
        echo "󱔐 [Preset] $name"
      fi
    done
  fi
}

# --- 3. SMART ATTACH & FREEZE (JSON OPTIMIZED) ---
smart_attach() {
  local target="$1"
  local project_root="$2"
  local final_session_name="$target"

  if [[ "$target" == "󱔐 [Preset] "* ]]; then
    final_session_name=$(echo "$target" | sed 's/󱔐 \[Preset\] //')
  fi

  if ! session_exists "$final_session_name"; then
    if [ -f "$TMUXP_CONFIG_DIR/${final_session_name}.json" ]; then
      echo " 󱔐 Baking layout (JSON): $final_session_name"
      tmuxp load -d -y "$final_session_name" >/dev/null 2>&1
    else
      echo " 󰙴 Creating generic session: $final_session_name"
      tmux new-session -d -s "$final_session_name" -c "${project_root:-$(pwd)}"
    fi
  fi

  if session_exists "$final_session_name"; then
    [ -n "$TMUX" ] && tmux switch-client -t "$final_session_name" || tmux attach-session -t "$final_session_name"
  fi
}

freeze_session() {
  local selected="$2"
  if [ -z "$selected" ]; then
    local sessions=$(list_all_sessions)
    [ -z "$sessions" ] && {
      echo "  No active sessions to freeze."
      return
    }
    selected=$(echo "$sessions" | fzf --prompt="󱔐 Select session to bake (JSON): " --height=40% --reverse --ansi)
  fi

  if [ -n "$selected" ]; then
    echo " 󱔐 Attempting to bake layout: $selected..."
    local output_path="$TMUXP_CONFIG_DIR/${selected}.json"

    # Chuyển đổi tham số nướng sang định dạng JSON (-f json)
    tmuxp freeze --save-to "$output_path" --quiet --force --yes "$selected" -f json

    if [ -f "$output_path" ]; then
      # Tùy chọn dọn dẹp lệnh cd thừa trong JSON (nếu có cài jq)
      if command -v jq >/dev/null 2>&1; then
        # Lọc bỏ các lệnh cd loằng ngoằng để file JSON sạch hơn
        jq 'walk(if type == "array" then map(select(tostring | contains("cd /") | not)) else . end)' "$output_path" >"${output_path}.tmp" && mv "${output_path}.tmp" "$output_path"
      fi

      echo " 󰙴 Successfully baked '$selected' to $output_path"
      [ -n "$TMUX" ] && tmux display-message "󱔐 Session $selected Baked (JSON)!"
    else
      echo " 󰚌 Error: JSON file generation failed."
    fi
  fi
}

# --- 4. GIAO DIỆN FZF ---
fzf_select_session() {
  local current_project="$1"
  local prompt_text="󰋼 Pick a session (Enter = new session for current dir): "
  local selection
  selection=$({
    echo "󰐕 [Create new session: $current_project]"
    list_available_tmuxp_presets
    tmux ls -F "󰈙 [Active] #{session_name}: #{session_windows} windows" 2>/dev/null
  } | fzf --prompt="$prompt_text" --height=40% --reverse --ansi --header="Presets tự động ẩn nếu đã chạy")

  local fzf_exit=$?
  [ $fzf_exit -ne 0 ] && return 1

  if [[ "$selection" == "󰐕 [Create new session:"* ]]; then
    return 2
  elif [[ "$selection" == "󱔐 [Preset] "* ]]; then
    echo "$selection"
    return 0
  elif [ -n "$selection" ]; then
    echo "$selection" | sed 's/󰈙 \[Active\] //' | cut -d: -f1
    return 0
  fi
}

# --- 5. MAIN ---
case "$1" in
--list | -l)
  tmux ls 2>/dev/null
  exit 0
  ;;
--kill-all)
  list_all_sessions | while read -r s; do tmux kill-session -t "$s"; done
  exit 0
  ;;
--freeze | -f)
  freeze_session "$1" "$2"
  exit 0
  ;;
esac

QUERY="$1"
PROJECT_ROOT=$(find_project_root "$(pwd)")
SESSION_NAME=$(generate_session_name "$PROJECT_ROOT")

if [ -n "$QUERY" ]; then
  if [ -f "$TMUXP_CONFIG_DIR/${QUERY}.json" ]; then
    smart_attach "󱔐 [Preset] $QUERY"
  else
    smart_attach "$QUERY" "$PROJECT_ROOT"
  fi
  exit 0
fi

SELECTED=$(fzf_select_session "$SESSION_NAME")
RET=$?
if [ $RET -eq 2 ]; then
  smart_attach "$SESSION_NAME" "$PROJECT_ROOT"
elif [ $RET -eq 0 ]; then
  smart_attach "$SELECTED"
fi
