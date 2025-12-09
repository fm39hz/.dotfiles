# Convienience aliases and environment variables for Fish shell
alias top "btop --force-utf"
# alias tmz "~/.config/scripts/zj_project.sh"
alias ls "exa --group-directories-first --icons --git --color-scale --long --header"
alias tm "~/.config/scripts/tmux_project.sh"
alias ff fastfetch

# Neovim aliases
alias nvim_set_default "~/.config/scripts/nvim_default_picker.sh"
alias nvim_direct_use "~/.config/scripts/nvim_direct_picker.sh"
alias nvim_delete "~/.config/scripts/nvim_delete.sh"
set -U SNACKS_GHOSTTY true

# QOL tools
fish_add_path -U "$HOME/.local/bin"

# Rust binary path
fish_add_path -U "$HOME/.cargo/bin"

# Android Dev environment
set -U ANDROID_HOME "$HOME/Android/Sdk"
fish_add_path -U "$ANDROID_HOME/platform-tools/"
fish_add_path -U "$ANDROID_HOME/tools/bin/"
fish_add_path -U "$ANDROID_HOME/emulator"
fish_add_path -U "$ANDROID_HOME/tools/"

# Dotnet
fish_add_path -U "$HOME/.dotnet/tools"
set -U DOTNET_WATCH_RESTART_ON_RUDE_EDIT true

# Laravel
fish_add_path -U "$HOME/.config/composer/vendor/bin"

# Flutter environment
# set -U PATH "$PATH:$HOME/.pub-cache/bin"
set -U CHROME_EXECUTABLE thorium-browser

# GodotEnv environment
alias godotenv "$HOME/.dotnet/tools/godotenv"
set -U GODOT "$HOME/.config/godotenv/godot/bin/godot"
fish_add_path -U "$HOME/.config/godotenv/godot/bin:$PATH"

# Aseprite environment
set -U STEAM_LIBRARY_PATH "$HOME/Hienpham/SteamLibrary/steamapps/common"
fish_add_path -U "$HOME/.local/share/Steam/steamapps/common/Aseprite"

# Docker alias
alias dockerup "docker-compose --log-level ERROR up -d --build"
alias dockerdown "docker-compose down"
