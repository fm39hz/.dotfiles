#!/usr/bin/env bash



set_wallpaper () {
	swww img "$1" -t grow --transition-pos top
}

run_hook () {
	$HOME/.hyprland_rice/autostart_$1
}

eww-rice () {
	eww --config ~/.config/hypr/eww/ $*
}
