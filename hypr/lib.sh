#!/usr/bin/env bash
#
# set_wallpaper() {
# 	wbg ~/.config/Wallpaper/japanese_pedestrian_street.png &
# }
function find_apps() {
  local search_term="$1"
  local search_by_class="${3:-false}"
  local window_pattern
  if [[ "$search_by_class" == "true" ]]; then
    # When searching by class, use the appropriate regex pattern
    window_pattern="class: ($search_term)"
  else
    # When searching by title, use the search term directly
    window_pattern="$search_term"
  fi
  echo window_pattern
}

# Function to bring a window to the current workspace in Hyprland
# Usage: bring_window_to_current <search_term> <app_class> [<search_by_class>] [<extra_args>]
bring_window_to_current() {
  local search_term="$1"
  local app_class="$2"
  local search_by_class="${3:-false}"
  local extra_args="${4:-}"

  # Construct the window search pattern
  window_pattern=$(find_apps search_term search_by_class)
  # Construct the command to execute if window isn't found
  local cmd
  if [[ -n "$extra_args" ]]; then
    cmd="$app_class $extra_args"
  else
    cmd="$app_class"
  fi

  # Use moveorexec to either move the window or execute the command
  echo "Searching for window: $window_pattern"
  echo "Command to execute if not found: $cmd"

  # Dispatch the command to Hyprland
  hyprctl dispatch plugin:xtd:moveorexec "$window_pattern, $cmd"
}

# Function to manage application focus in Hyprland based on app name/class
# Usage: manage_focus <search_term> <app_class> [<target_workspace>] [<search_by_class>] [<extra_args>]
manage_focus() {
  local search_term="$1"
  local app_class="$2"
  local target_workspace="$3"
  local search_by_class="${4:-false}"
  local extra_args="$5"
  local rg_pattern=""

  # Set the rg pattern based on whether we're searching by class or title
  if [[ "$search_by_class" == "true" ]]; then
    rg_pattern="class: $search_term"
  else
    rg_pattern="$search_term"
  fi

  # Function to retrieve and process workspace information
  get_workspace() {
    local pattern="$1"
    local workspace

    # Try to get workspace from column 2
    workspace=$(hyprctl clients | rg -B 5 "$pattern" | rg "workspace" | awk '{print $2}' | head -n 1)

    # Check if the workspace is numeric and greater than 0
    if [[ ! "$workspace" =~ ^[0-9]+$ ]] || ((workspace < 0)); then
      # Try column 3 and remove parentheses if needed
      workspace=$(hyprctl clients | rg -B 5 "$pattern" | rg "workspace" | awk '{print $3}' | head -n 1 | sed 's/[()]//g')
    fi
    echo "$workspace"
  }

  # Check if any window with the search term exists
  echo "Checking for existing window for $rg_pattern"
  if hyprctl clients | rg -q "$rg_pattern"; then
    # If an app window is open, find its workspace
    echo "Found existing window for $search_term"
    target_workspace=$(get_workspace "$rg_pattern")
    hyprctl dispatch workspace "$target_workspace"
    return
  fi
  hyprctl dispatch workspace "$target_workspace"
  hyprctl dispatch plugin:xtd:moveorexec "$rg_pattern", "app2unit -s b $app_class"
}
function close_apps() {
  BRAVE=$(find_apps brave-browser-nightly | wc -l)
  CHROMIUM=$(find_apps chromium true | wc -l)
  FIREFOX=$(find_apps firefox true | wc -l)

  if [ "$BRAVE" -gt "1" ]; then
    notify-send "power controls" "Brave multiple windows open"
    exit 1
  elif [ "$CHROMIUM" -gt "1" ]; then
    notify-send "power controls" "Chromium multiple windows open"
    exit 1
  elif [ "$FIREFOX" -gt "1" ]; then
    notify-send "power controls" "Firefox multiple windows open"
    exit 1
  fi

  sleep 3

  # close all client windows
  # required for graceful exit since many apps aren't good SIGNAL citizens
  HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
  temp_dir="tmp/hypr"
  mkdir -p $temp_dir
  hyprctl --batch "$HYPRCMDS" >>$temp_dir/hyprexitwithgrace.log 2>&1

  notify-send "Power controls" "Closing Applications..."

  sleep 2

  COUNT=$(find_apps "class:" | wc -l)
  if [ "$COUNT" -eq "0" ]; then
    notify-send "Power controls" "Closed Applications."
    return
  else
    notify-send "Power controls" "Some apps didn't close. Not shutting down."
    exit 1
  fi
}
