#!/bin/bash

TMUXP_CONFIG_DIR="$HOME/.config/tmuxp"

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

generate_session_name() {
  local project_root="$1"
  local project_name="${project_root##*/}"
  project_name="${project_name#.}"
  echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' .' '-'
}

fzf_select_session() {
  local current_project="$1"

  get_data() {
    echo "󰐕 [Create: $1]"
    tmux ls -F "󰈙 [Active] #{session_name}: #{session_windows} windows" 2>/dev/null
    [ -d "$TMUXP_CONFIG_DIR" ] && fd -e json . "$TMUXP_CONFIG_DIR" --exec-batch basename -s .json | sed 's/^/󱔐 [Preset] /'
    zoxide query -l | sed 's/^/📁 [Zoxide] /'
  }

  export -f get_data
  export TMUXP_CONFIG_DIR

  selection=$(get_data "$current_project" | awk '
    {
      if ($2 == "[Active]") { name = $3; sub(/:$/, "", name) }
      else if ($2 == "[Preset]") { name = $3 }
      else if ($2 == "[Zoxide]") { n = split($3, a, "/"); name = a[n] }
      else { name = $0 }
      if (name != "" && !visited[name]++) print $0
    }' | fzf --prompt="󰋼 Sesh: " --height=40% --reverse --ansi --no-sort --tiebreak=index \
    --header "Alt-x: Kill Session | Alt-b: Freeze Layout | Ctrl-j/k: Move" \
    --bind "alt-x:execute(tmux kill-session -t \$(echo {} | sed -E 's/.*\[Active\] ([^:]+):.*/\1/'))+reload(bash -c 'get_data $current_project' | awk '!visited[\$0]++')" \
    --bind "alt-b:execute(tmuxp freeze \$(echo {} | sed -E 's/.*\[Active\] ([^:]+):.*/\1/') --yes --force -f json -o $TMUXP_CONFIG_DIR/\$(echo {} | sed -E 's/.*\[Active\] ([^:]+):.*/\1/').json)+become(echo {})")

  [ $? -ne 0 ] && return 1
  echo "$selection"
}

smart_connect() {
  local selection="$1"
  local session_name="$2"
  local target=""

  if [[ "$selection" == "󰐕 [Create:"* ]]; then
    target="$session_name"
  elif [[ "$selection" == "󰈙 [Active] "* ]]; then
    target=$(echo "$selection" | sed -E 's/.*\[Active\] ([^:]+):.*/\1/')
  elif [[ "$selection" == "󱔐 [Preset] "* ]]; then
    target="${selection#*] }"
  elif [[ "$selection" == "📁 [Zoxide] "* ]]; then
    target="${selection#*] }"
  fi

  local bname
  bname=$(basename "$target")
  if ! tmux has-session -t "$bname" 2>/dev/null; then
    if [ -f "$TMUXP_CONFIG_DIR/${bname}.json" ]; then
      echo "󱔐 Baking layout: $bname"
      tmuxp load -d -y "$bname" >/dev/null 2>&1
    fi
  fi

  sesh connect "$target"
}

case "$1" in
-f | --freeze)
  session=$(tmux ls -F "#{session_name}" | fzf --reverse --prompt="Freeze Session: ")
  [ -n "$session" ] && tmuxp freeze "$session" --yes --force -f json -o "$TMUXP_CONFIG_DIR/${session}.json"
  exit 0
  ;;
esac

PROJECT_ROOT=$(find_project_root "$(pwd)")
NAME=$(generate_session_name "$PROJECT_ROOT")

SELECTED=$(fzf_select_session "$NAME")
[ -n "$SELECTED" ] && smart_connect "$SELECTED" "$NAME"
