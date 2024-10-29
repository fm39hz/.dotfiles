#!/bin/bash

# Define the class name for Zen Browser in Hyprland
browser_name="Zen Browser"
browser_class="zen-browser"

# Function to retrieve the workspace information by column number
get_workspace() {
  hyprctl clients | grep -A 10 "$browser_name" | grep "workspace" | awk -v col="$1" '{print $col}' | head -n 1
}

# Check if any window with the class name exists
if hyprctl clients | grep -q "$browser_name"; then
  # If a Zen Browser window is open, find its workspace
  workspace=$(get_workspace 2)
  # Check if the workspace is numeric and smaller than 0
  if [[ ! "$workspace" =~ ^[0-9]+$ ]] && ((workspace < 0)); then
    workspace=$(get_workspace 3 | sed 's/[()]//g') # Remove parentheses from workspace name
  fi
  # Focus on the workspace
  hyprctl dispatch workspace "$workspace"
else
  # If the browser is not running, start it
  $browser_class &
fi
