#!/usr/bin/env bash
#
# set_wallpaper() {
# 	wbg ~/.config/Wallpaper/japanese_pedestrian_street.png &
# }

# Function to bring a window to the current workspace in Hyprland
# Usage: bring_window_to_current <search_term> <app_class> [<search_by_class>] [<extra_args>]
bring_window_to_current() {
	local search_term="$1"
	local app_class="$2"
	local search_by_class="${3:-false}"
	local extra_args="${4:-}"

	# Construct the window search pattern
	local window_pattern
	if [[ "$search_by_class" == "true" ]]; then
		# When searching by class, use the appropriate regex pattern
		window_pattern="class: ($search_term)"
	else
		# When searching by title, use the search term directly
		window_pattern="$search_term"
	fi

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
	local grep_pattern=""

	# Set the grep pattern based on whether we're searching by class or title
	if [[ "$search_by_class" == "true" ]]; then
		grep_pattern="class: $search_term"
	else
		grep_pattern="$search_term"
	fi

	# Function to retrieve and process workspace information
	get_workspace() {
		local pattern="$1"
		local workspace

		# Try to get workspace from column 2
		workspace=$(hyprctl clients | rg -B 5 "$pattern" | grep "workspace" | awk '{print $2}' | head -n 1)

		# Check if the workspace is numeric and greater than 0
		if [[ ! "$workspace" =~ ^[0-9]+$ ]] || ((workspace < 0)); then
			# Try column 3 and remove parentheses if needed
			workspace=$(hyprctl clients | rg -B 5 "$pattern" | grep "workspace" | awk '{print $3}' | head -n 1 | sed 's/[()]//g')
		fi
		echo "$workspace"
	}

	# Check if any window with the search term exists
	echo "Checking for existing window for $grep_pattern"
	if hyprctl clients | rg -q "$grep_pattern"; then
		# If an app window is open, find its workspace
		echo "Found existing window for $search_term"
		target_workspace=$(get_workspace "$grep_pattern")
		hyprctl dispatch workspace "$target_workspace"
		return
	fi
	hyprctl dispatch workspace "$target_workspace"
	hyprctl dispatch plugin:xtd:moveorexec "$grep_pattern", "uwsm app -- $app_class"
}
