#!/bin/bash
hyprctl keyword monitor "e-DP-1, enable" &
hyprctl reload &
~/.config/hypr/scripts/hyprpanel.sh
app2unit -s b hyprpanel
hyprlock
