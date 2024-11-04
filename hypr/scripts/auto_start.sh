#!/usr/bin/env bash

source "$HOME"/.config/hypr/lib.sh

swww init

set_wallpaper

eval "hypridle" &

~/.config/waybar/start
~/.config/swaync/start
~/.config/eww/start

eval "hyprlock" &

nm-applet &
blueman-applet &

lxsession &

brightnessctl --restore

eval "hyprctl setcursor everforest-cursors 32;" &

eval "sleep 1; fcitx5" &
# eval "localsend; sleep 15; hyprctl dipatch closewindow localsend" &
eval "sleep 0.5; hyprctl reload" &
