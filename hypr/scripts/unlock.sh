#!/bin/bash
hyprctl keyword monitor "e-DP-1, enable" &
hyprctl reload &
# hyprpanel
dms ipc call lock lock
