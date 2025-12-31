$env.config.edit_mode = 'vi'
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.LS_COLORS = (vivid generate ~/.config/vivid/everforest.yml)
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
$env.config.edit_mode = 'vi'
# Ép .NET hiển thị màu trong Nushell
$env.DOTNET_SYSTEM_CONSOLE_ALLOW_ANSI_COLOR_REDIRECTION = "true"
# mkdir ~/.cache/carapace
# carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# Path definition
let cargo_bin = ($env.HOME | path join .cargo bin)
let go_bin = ($env.HOME | path join go bin)

# Add path
$env.PATH = ($env.PATH | split row (char esep) | append $cargo_bin | append $go_bin | uniq)
