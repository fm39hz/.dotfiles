# Vi mode
set -g fish_key_bindings fish_vi_key_bindings

# Zoxide
zoxide init fish | source

# Spicetify
fish_add_path /home/fm39hz/.spicetify

# Carapace
# set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
# carapace _carapace | source
#
# LM Studio
set -gx PATH $PATH /home/fm39hz/.cache/lm-studio/bin

# The Fuck
thefuck --alias | source

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
set fzf_preview_dir_cmd eza --all --color=always
