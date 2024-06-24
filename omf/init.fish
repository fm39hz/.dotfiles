# Fish configuration
set -U fish_greeting
set -U fish_prompt_pwd_dir_length 10
set -U fish_escape_delay_ms 10
set -U fish_cursor_default block
set -U fish_cursor_insert line

# Convenient config
set -U LANG en_US.UTF-8
set -U LC_ALL en_US.UTF-8
set -U EDITOR nvim
alias top "btop --utf-force"
alias nvim_set_default "~/.config/scripts/nvim_default_picker.sh"
alias nvim_direct_use "~/.config/scripts/nvim_direct_picker.sh"
alias nvim_delete "~/.config/scripts/nvim_delete.sh"

# Android Dev environment
set -U ANDROID_HOME "$HOME/Android/Sdk"
set -U PATH $PATH:$ANDROID_HOME/platform-tools/
set -U PATH $PATH:$ANDROID_HOME/tools/bin/
set -U PATH $PATH:$ANDROID_HOME/emulator
set -U PATH $PATH:$ANDROID_HOME/tools/

# Flutter environment
# export PATH="$PATH:$HOME/.pub-cache/bin"
set -U CHROME_EXECUTABLE thorium-browser

# GodotEnv environment
alias godotenv "$HOME/.dotnet/tools/godotenv"
set -U GODOT "$HOME/.config/godotenv/godot/bin/godot"
set -U PATH "$HOME/.config/godotenv/godot/bin:$PATH"

# Docker alias
alias dockerup "docker-compose --log-level ERROR up -d --build"
alias dockerdown "docker-compose down"
