#!/bin/bash

status="$(nmcli general status | rg -oh "\w*connect\w*")"
wifi=""

if [[ "$status" == "disconnected" ]]; then
  wifi="󰤮 "
elif [[ "$status" == "connecting" ]]; then
  wifi="󱍸 "
elif [[ "$status" == "connected" ]]; then
  # strength="$(nmcli -f IN-USE,SIGNAL device wifi | rg '*' | awk '{print $2}')"
  strength="$(python ~/.config/hypr/scripts/wifi_conn_strength)"
  if [[ "$?" == "0" ]]; then
    if [[ "$strength" -eq "0" ]]; then
      wifi="󰤯 "
    elif [[ ("$strength" -ge "0") && ("$strength" -le "25") ]]; then
      wifi="󰤟 "
    elif [[ ("$strength" -ge "25") && ("$strength" -le "50") ]]; then
      wifi="󰤢 "
    elif [[ ("$strength" -ge "50") && ("$strength" -le "75") ]]; then
      wifi="󰤥 "
    elif [[ ("$strength" -ge "75") && ("$strength" -le "100") ]]; then
      wifi="󰤨 "
    fi
  else
    wifi="󰈀 "
  fi
fi

echo "<span>$wifi</span>"
