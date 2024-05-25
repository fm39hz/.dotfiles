#!/usr/bin/bash

if [ "$(whoami)" != "root" ] && [ "$(tty)" == "/dev/tty1" ];
then
	Hyprland
else
	neofetch
fi
