#!/bin/bash

# Retrieve exist config
config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
[[ -z $config ]] && echo "No config selected" && exit

# Create Distro
distro_name=$(basename "$config")
# Backup local config
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Create symbolic links
ln -s ~/.config/"${distro_name}" ~/.config/nvim
ln -s ~/.local/share/"${distro_name}" ~/.local/share/nvim
ln -s ~/.local/state/"${distro_name}" ~/.local/state/nvim
ln -s ~/.cache/"${distro_name}" ~/.cache/nvim

echo "Symbolic links created with '$distro_name'."
