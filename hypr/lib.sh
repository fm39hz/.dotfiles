#!/usr/bin/env bash

set_wallpaper() {
	wbg ~/.config/Wallpaper/japanese_pedestrian_street.png &
}

run_hook() {
	$HOME/.hyprland_rice/autostart_$1
}

eww-rice() {
	eww --config ~/.config/eww/ $*
}
