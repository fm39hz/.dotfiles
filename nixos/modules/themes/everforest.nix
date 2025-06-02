# ~/.config/nixos/modules/themes/everforest.nix - ENHANCED with theme packages
{ config, lib, pkgs, ... }:
let cfg = config.modules.themes.everforest;
in {
  options.modules.themes.everforest.enable = lib.mkEnableOption "Everforest theme";
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # GTK themes (manual installation might be needed for specific themes)
      gnome.gnome-themes-extra
      gtk-engine-murrine
      sassc
      
      # Note: colloid-everforest-gtk-theme-git and everforest-icon-theme-git
      # are AUR packages, may need manual theme installation
    ];

    # Everforest color scheme
    environment.sessionVariables = {
      EVERFOREST_BG = "#2d353b";
      EVERFOREST_FG = "#d3c6aa"; 
      EVERFOREST_GREEN = "#a7c080";
      EVERFOREST_YELLOW = "#dbbc7f";
      EVERFOREST_RED = "#e67e80";
      EVERFOREST_BLUE = "#7fbbb3";
      EVERFOREST_PURPLE = "#d699b6";
      EVERFOREST_AQUA = "#83c092";
      EVERFOREST_ORANGE = "#e69875";
    };
  };
}
