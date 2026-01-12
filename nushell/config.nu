# Ghi chú: Starship và Zoxide đã được nạp tự động qua vendor/autoload

source ~/.config/nushell/completer.nu

# Aliases
alias top = btop --force-utf
alias ll = ls -l
alias la = ls -a
alias ff = fastfetch
alias lzg = lazygit
alias lzd = lazydocker
alias nvim_set_default = ~/.config/scripts/nvim_default_picker.sh
alias nvim_direct_use = ~/.config/scripts/nvim_direct_picker.sh
alias nvim_delete = ~/.config/scripts/nvim_delete.sh
alias tm = ~/.config/scripts/tmux_project.sh

# Environment Configuration
$env.config = {
    show_banner: false

    keybindings: [
      {
        name: toggle_sudo
        modifier: alt
        keycode: char_s
        mode: [emacs, vi_insert, vi_normal]
        event: {
          send: ExecuteHostCommand
          cmd: "
            let line = (commandline)
            let target = if ($line | is-empty) {
                history | last 1 | get command | get 0 | str trim
            } else {
                $line
            }

            if ($target | str starts-with 'sudo ') {
                commandline edit --replace ($target | str substring 5..)
            } else {
                commandline edit --replace ($'sudo ($target)')
            }
          "
        }
      },
      {
        name: launch_tmux_manager
        modifier: control
        keycode: char_b
        mode: [emacs, vi_normal, vi_insert]
        event: {
          send: ExecuteHostCommand
          cmd: "
            if ($env | get -o TMUX | is-empty) {
                ~/.config/scripts/tmux_project.sh
            } else {
                print 'Bạn đang ở trong Tmux rồi!'
            }
          "
        }
      },
      {
        name: launch_tmux_manager
        modifier: control
        keycode: char_y
        mode: [emacs, vi_normal, vi_insert]
        event: {
          send: ExecuteHostCommand
          cmd: "yazi"
        }
      },
      {
        name: hard_clear_screen
        modifier: alt
        keycode: char_l
        mode: [emacs, vi_normal, vi_insert]
        event: {
          send: ExecuteHostCommand
          cmd: "clear"
        }
      }
    ]
}
