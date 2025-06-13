# ~/.config/nixos/modules/programs/development.nix - ENHANCED with all dev tools
{ config, lib, pkgs, ... }:
let cfg = config.modules.programs.development;
in {
  config = lib.mkIf cfg.enable {
    programs = {
      git.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # Version control
      git git-lfs lazygit github-cli

      # Editors  
      neovim neovide zed-editor vscode

      # Languages & runtimes
      rustc cargo nodejs npm
      dotnet-sdk dotnet-sdk_8 aspnetcore-runtime
      jdk17 maven php composer
      lua51 luarocks go python3 python3Packages.pip
      
      # Build tools
      gcc clang gnumake cmake pkg-config ninja nasm
      
      # Terminal tools
      tmux btop fish starship
      fzf ripgrep fd tree yazi zoxide
      fastfetch lshw acpi figlet cmatrix
      entr gum diff-so-fancy grc thefuck
      
      # System utilities
      wget curl rsync unzip unrar p7zip
      plocate man-db inetutils wmctrl
      
      # Containers
      docker docker-buildx docker-compose
      
      # Database
      mariadb
      
      # Network tools
      nmap iw cloudflared
      
      # Documentation
      graphviz plantuml
    ];
    
    # Enable Docker service integration
    virtualisation.docker.enable = lib.mkDefault true;
  };
}
