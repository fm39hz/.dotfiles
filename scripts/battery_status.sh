#!/bin/bash

# status="$(acpi -b | rg -ioh "\w*charging\w*")"
# level="$(acpi -b | rg -o -P "[0-9]+(?=%)")"

status="$(cat /sys/class/power_supply/BAT0/status)"
level="$(cat /sys/class/power_supply/BAT0/capacity)"

output=""
if [[ ("$status" == "Discharging") || ("$status" == "Full") ]]; then
  if [[ "$level" -eq "0" ]]; then
    output=" "
  elif [[ ("$level" -ge "0") && ("$level" -le "25") ]]; then
    output=" "
  elif [[ ("$level" -ge "25") && ("$level" -le "50") ]]; then
    output=" "
  elif [[ ("$level" -ge "50") && ("$level" -le "75") ]]; then
    output=" "
  elif [[ ("$level" -ge "75") && ("$level" -le "100") ]]; then
    output=" "
  fi
elif [[ "$status" == "Charging" ]]; then
  output=" "
fi

echo "<span>$output</span>"
