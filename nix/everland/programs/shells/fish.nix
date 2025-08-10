{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      grep = "grep --color=auto";
      vi = "nvim";
      vim = "nvim";
    };

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      mkcd = {
        body = "mkdir -p $argv[1]; and cd $argv[1]";
        description = "Create a directory and cd into it";
      };
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
      
      # Export environment variables
      set -gx EDITOR nvim
      set -gx BROWSER firefox
      
      # History configuration
      set -g fish_history_max 10000
    '';
  };
}