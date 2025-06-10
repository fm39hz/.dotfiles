zoxide init nushell | save -f ~/.zoxide.nu
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.LS_COLORS = (vivid generate ~/.config/vivid/everforest.yml)
