# ~/.config/nixos/home/default.nix - Link to existing dotfiles properly
{ config, pkgs, inputs, ... }: {
  imports = [
    ./programs
  ];

  home = {
    username = "fm39hz";
    homeDirectory = "/home/fm39hz";
    stateVersion = "25.05";
  };

  # Use your existing dotfiles (they're already working)
  home.file = {
    # Link to your existing configs without modification
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/hypr";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/waybar";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/rofi";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/fish";
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/btop";
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/yazi";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/zathura";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/ghostty";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/kitty";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/tmux";
  };

  programs.home-manager.enable = true;

  # Enable everforest theme
  modules.themes.everforest.enable = true;
}
