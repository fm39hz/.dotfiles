fenv "source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
# Fish configuration
set -U fish_prompt_pwd_dir_length 10
set -U fish_escape_delay_ms 10
set -U fish_cursor_default block
set -U fish_cursor_insert line

# Color config
set -U fish_color_selection --background=7A8478 --foreground=232A2E
set -U fish_color_search_match --background=7A8478 --foreground=232A2E

# Convenient config
set -U LANG en_US.UTF-8
set -U LC_ALL en_US.UTF-8
set -U EDITOR nvim
alias top "btop --utf-force"
alias tma "tmux a -t"
alias tmn "tmux new -s"
alias tml "tmux ls"

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

# Dotnet path
fish_add_path -U "$HOME/.dotnet/tools"

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
