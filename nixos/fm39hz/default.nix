# ~/.config/nixos/home/default.nix (MISSING)
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./programs
    ./services
  ];

  home = {
    username = "fm39hz";
    homeDirectory = "/home/fm39hz";
    stateVersion = "25.05";
  };

  # Link your existing dotfiles
  home.file = {
    ".config/hypr".source = ../hypr;
    ".config/fish".source = ../fish;
    ".config/ghostty".source = ../ghostty;
    ".config/btop".source = ../btop;
    ".config/yazi".source = ../yazi;
    ".config/zathura".source = ../zathura;
    ".config/wlogout".source = ../wlogout;
    ".config/tmux".source = ../tmux;
    ".config/hyprpanel".source = ../hyprpanel;
  };

  programs.home-manager.enable = true;
}
