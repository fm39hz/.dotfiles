#!/bin/bash
# hyprpanel -q
# app2unit -s b hyprpanel

kill "$(pidof qs)"
runapp dms run
# ~/.config/quickshell/run.fish
