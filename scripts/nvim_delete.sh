#!/bin/bash

# Retrieve exist config
configs=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
[[ -z $configs ]] && echo "No config selected" && exit

# Create Distro
distros=$(basename "$configs")

# Link Distro
directories=(~/.config ~/.local/share ~/.local/state ~/.cache)
for dir in "${directories[@]}"; do
	rm -rf "${dir:?}/$distros"
done

echo "Deleted '$distros'."
