mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
source ~/.config/nushell/completer.nu
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
# alias sysclear = yay -Qdtq | yay -Rns -
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
            
            # Xác định đối tượng cần xử lý: dòng hiện tại hoặc lịch sử
            let target = if ($line | is-empty) {
                # Lấy lệnh cuối cùng, 'str trim' để xóa ký tự xuống dòng thừa nếu có
                history | last 1 | get command | get 0 | str trim
            } else {
                $line
            }

            # Logic toggle sudo
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
            # Kiểm tra xem có đang trong tmux không
            if ($env | get -o TMUX | is-empty) {
                tm
            } else {
                # (Tùy chọn) In ra thông báo nếu lỡ bấm nhầm trong tmux
                print 'Bạn đang ở trong Tmux rồi!'
            }
          "
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
