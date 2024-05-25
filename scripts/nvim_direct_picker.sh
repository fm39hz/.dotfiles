#!/bin/bash

# Assumes all configs exist in directories named ~/.config/nvim-*
configs_dir="$HOME/.config"
config=$(fd --max-depth 1 --glob 'nvim-*' "$configs_dir" | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

# If I exit fzf without selecting a config, don't open Neovim
if [[ -z $config ]]; then
	echo "No config selected"
	exit 1
fi

# Open Neovim with the selected config
NVIM_APPNAME=$(basename "$config") nvim "$@"
