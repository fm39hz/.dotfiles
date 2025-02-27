#!/usr/bin/env bash

set_wallpaper() {
	wbg ~/.config/Wallpaper/japanese_pedestrian_street.png &
}

eww-rice() {
	eww --config ~/.config/eww/ $*
}

# Function to manage application focus in Hyprland based on app name/class
# Usage: manage_focus <search_term> <app_class> [<target_workspace>] [<search_by_class>] [<extra_args>]
manage_focus() {
	local search_term="$1"
	local app_class="$2"
	local target_workspace="$3"
	local search_by_class="${4:-false}" # Optional parameter, defaults to false
	local extra_args="${5:-""}"         # Optional parameter, defaults to empty string
	local grep_pattern=""

	# Set the grep pattern based on whether we're searching by class or title
	if [[ "$search_by_class" == "true" ]]; then
		grep_pattern="class: $search_term"
	else
		grep_pattern="$search_term"
	fi

	# Function to retrieve the workspace information by column number
	get_workspace() {
		local pattern="$1"
		local col="$2"
		hyprctl clients | rg -B 5 "$pattern" | grep "workspace" | awk -v col="$col" '{print $col}' | head -n 1
	}

	# Check if any window with the search term exists
	if hyprctl clients | rg -q "$grep_pattern"; then
		# If an app window is open, find its workspace
		target_workspace=$(get_workspace "$grep_pattern" 2)
		echo "Found $search_term on workspace $target_workspace"
		# Check if the workspace is numeric and greater than 0
		if [[ ! "$target_workspace" =~ ^[0-9]+$ ]] || ((target_workspace < 0)); then
			target_workspace=$(get_workspace "$grep_pattern" 3 | sed 's/[()]//g') # Remove parentheses from workspace name
		fi
		# Focus on the workspace
		hyprctl dispatch workspace "$target_workspace"
	else
		# If the app is not running, start it
		hyprctl dispatch workspace "$target_workspace"
		# Use -- to indicate the end of options for browsers like Brave
		if [[ "$app_class" == "brave" || "$app_class" == "brave-browser" ]]; then
			$app_class -- $extra_args &
		else
			$app_class $extra_args &
		fi
	fi
}
