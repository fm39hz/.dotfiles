# === Vi mode ===
fish_vi_key_bindings
fish_user_key_bindings  # apply custom bindings after vi mode

# === Cursor shape ===
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_escape_delay_ms 10
set -g fish_prompt_pwd_dir_length 10

# === Zoxide ===
zoxide init fish | source

# === The Fuck ===
thefuck --alias | source

# === Editor ===
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx SNACKS_GHOSTTY true
set -gx DOTNET_WATCH_RESTART_ON_RUDE_EDIT true
set -gx CHROME_EXECUTABLE thorium-browser

# === Android SDK ===
set -gx ANDROID_HOME "$HOME/Android/Sdk"
fish_add_path "$ANDROID_HOME/platform-tools"
fish_add_path "$ANDROID_HOME/tools/bin"
fish_add_path "$ANDROID_HOME/emulator"
fish_add_path "$ANDROID_HOME/tools"

# === Rust/Cargo ===
fish_add_path "$HOME/.cargo/bin"

# === Go ===
fish_add_path "$HOME/go/bin"

# === .NET ===
fish_add_path "$HOME/.dotnet/tools"

# === Local bin ===
fish_add_path "$HOME/.local/bin"

# === Laravel ===
fish_add_path "$HOME/.config/composer/vendor/bin"

# === Aseprite (Steam) ===
set -gx STEAM_LIBRARY_PATH "$HOME/Hienpham/SteamLibrary/steamapps/common"
fish_add_path "$HOME/.local/share/Steam/steamapps/common/Aseprite"

# === Godot ===
set -gx GODOT "$HOME/.config/godotenv/godot/bin/godot"
fish_add_path "$HOME/.config/godotenv/godot/bin"

# === LM Studio ===
fish_add_path "$HOME/.cache/lm-studio/bin"

# === Spicetify ===
fish_add_path "$HOME/.spicetify"

# === Aliases ===
alias top "btop --force-utf"
alias ls "exa --group-directories-first --icons --git --color-scale --long --header"
alias tm "~/.config/scripts/tmux_project.sh"
alias ff fastfetch
alias nvim_set_default "~/.config/scripts/nvim_default_picker.sh"
alias nvim_direct_use "~/.config/scripts/nvim_direct_picker.sh"
alias nvim_delete "~/.config/scripts/nvim_delete.sh"
alias dockerup "docker-compose --log-level ERROR up -d --build"
alias dockerdown "docker-compose down"
