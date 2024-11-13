#!/usr/bin/env bash

set_wallpaper() {
	wbg ~/.config/Wallpaper/japanese_pedestrian_street.png &
}

eww-rice() {
	eww --config ~/.config/eww/ $*
}

# Function to manage application focus in Hyprland based on app name and class
# Usage: manage_focus <app_name> <app_class>
manage_focus() {
	local app_name="$1"
	local app_class="$2"
	local target_workspace="$3"

	# Function to retrieve the workspace information by column number
	get_workspace() {
		hyprctl clients | grep -A 10 "$app_name" | grep "workspace" | awk -v col="$1" '{print $col}' | head -n 1
	}

	# Check if any window with the app name exists
	if hyprctl clients | grep -q "$app_name"; then
		# If an app window is open, find its workspace
		target_workspace=$(get_workspace 2)
		# Check if the workspace is numeric and greater than 0
		if [[ ! "$target_workspace" =~ ^[0-9]+$ ]] && ((target_workspace < 0)); then
			target_workspace=$(get_workspace 3 | sed 's/[()]//g') # Remove parentheses from workspace name
		fi
		# Focus on the workspace
		hyprctl dispatch workspace "$target_workspace"
	else
		# If the app is not running, start it
		hyprctl dispatch workspace "$target_workspace"
		$app_class &
	fi
}
