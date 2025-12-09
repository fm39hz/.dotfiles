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
alias tm = ~/.config/scripts/tmux_project.sh
# alias sysclear = yay -Qdtq | yay -Rns -
def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    {
      options: {
        sort: false,
        completion_algorithm: prefix,
        positional: false,
        case_sensitive: false,
      },
      completions: (zoxide query --list --exclude $env.PWD -- ...$parts | lines),
    }
  }

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}
  $env.config = {
    show_banner: false

    keybindings: [
      {
        name: toggle_sudo
        modifier: alt
        keycode: char_s
        mode: [emacs, vi_insert, vi_normal] # Hoạt động ở mọi chế độ
        event: {
          send: ExecuteHostCommand
          cmd: "
            let line = (commandline)
            if ($line | str starts-with 'sudo ') {
                commandline edit --replace ($line | str substring 5..)
            } else {
                commandline edit --replace ($'sudo ($line)')
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
