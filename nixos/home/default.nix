# ~/.config/nixos/home/default.nix
{ config, pkgs, inputs, ... }: {
  imports = [
    ./programs
  ];

  home = {
    username = "fm39hz";
    homeDirectory = "/home/fm39hz";
    stateVersion = "25.05";
  };

  # Link your existing dotfiles (proper way)
  home.file = {
    ".config/hypr".source = ../hypr;
    ".config/fish".source = ../fish;
    ".config/ghostty".source = ../ghostty;
    ".config/btop".source = ../btop;
    ".config/yazi".source = ../yazi;
    ".config/zathura".source = ../zathura;
    ".config/tmux".source = ../tmux;
    ".config/hyprpanel".source = ../hyprpanel;
    ".config/rofi".source = ../rofi;
    ".config/waybar".source = ../waybar;
    ".config/kitty".source = ../kitty;
    ".config/omf".source = ../omf;
    ".config/fontconfig".source = ../fontconfig;
    ".config/wal".source = ../wal;
    ".config/nwg-look".source = ../nwg-look;
    ".config/qt5ct".source = ../qt5ct;
    ".config/keyd".source = ../keyd;
    ".config/greetd".source = ../greetd;
    ".config/scripts".source = ../scripts;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
    TERMINAL = "ghostty";
    SNACKS_GHOSTTY = "true";
  };

  # Essential packages for user
  home.packages = with pkgs; [
    # Terminal tools
    bat eza fd ripgrep tree jq
    fastfetch btop htop
    
    # Development
    git lazygit gh
    
    # Multimedia
    playerctl pamixer
    
    # File management
    xarchiver unzip unrar p7zip
    
    # Network
    networkmanagerapplet
  ];
}
