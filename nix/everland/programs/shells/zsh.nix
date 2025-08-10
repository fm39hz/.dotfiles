{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "npm"
        "node"
        "python"
        "rust"
        "golang"
      ];
    };

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };

    initContent = ''
      # Custom zsh configuration
      export EDITOR="nvim"
      export BROWSER="firefox"
      
      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
    '';
  };
}