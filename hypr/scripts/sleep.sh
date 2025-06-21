#!/bin/bash
if [ "$(acpi -a)" == "Adapter 0: on-line" ]; then
  hyprctl keyword monitor "eDP-1, disable"
fi
powerprofilesctl set power-saver
