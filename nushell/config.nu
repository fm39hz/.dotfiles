mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
source ~/.config/nushell/completer.nu
alias ll = ls -l
alias la = ls -a
alias lzg = lazygit
alias lzd = lazydocker
alias tma = tmux a -t
alias tmn = tmux new -s
alias tml = tmux ls
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
