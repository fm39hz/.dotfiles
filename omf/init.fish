# Fish configuration
set -g fish_greeting
set -g fish_prompt_pwd_dir_length 0

# Convenient config
set -g LANG en_US.UTF-8
set -g LC_ALL en_US.UTF-8
set -g EDITOR nvim
alias top "btop --utf-force"
alias nvim_set_default "~/.config/scripts/nvim_default_picker.sh"
alias nvim_direct_use "~/.config/scripts/nvim_direct_picker.sh"
alias nvim_delete "~/.config/scripts/nvim_delete.sh"

# Android Dev environment
set -g ANDROID_HOME "$HOME/Android/Sdk"
set -g PATH $PATH:$ANDROID_HOME/platform-tools/
set -g PATH $PATH:$ANDROID_HOME/tools/bin/
set -g PATH $PATH:$ANDROID_HOME/emulator
set -g PATH $PATH:$ANDROID_HOME/tools/

# Flutter environment
# export PATH="$PATH:$HOME/.pub-cache/bin"
set -g CHROME_EXECUTABLE thorium-browser

# GodotEnv environment
alias godotenv "$HOME/.dotnet/tools/godotenv"
set -g GODOT "$HOME/.config/godotenv/godot/bin/godot"
set -g GODOT "/home/fm39hz/.config/godotenv/godot/bin/godot"
set -g PATH "$HOME/.config/godotenv/godot/bin:$PATH"
set -g PATH "/home/fm39hz/.config/godotenv/godot/bin:$PATH"

# Docker alias
alias dockerup "docker-compose --log-level ERROR up -d --build"
alias dockerdown "docker-compose down"
