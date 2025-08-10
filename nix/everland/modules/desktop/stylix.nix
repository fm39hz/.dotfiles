{ personal, pkgs, lib, ... }:
let
  # Centralized theme configuration - change this to switch themes
  currentTheme = "everforest"; # Options: everforest, catppuccin-mocha, gruvbox, etc.
  
  # Theme definitions
  themes = {
    everforest = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/ForestStairCase.png";
      polarity = "dark";
    };
    catppuccin-mocha = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/catppuccin-mocha.png";
      polarity = "dark";
    };
    gruvbox = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/gruvbox.png";
      polarity = "dark";
    };
    dracula = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/dracula.png";
      polarity = "dark";
    };
  };
  
  selectedTheme = themes.${currentTheme};
in
{
  stylix = {
    enable = true;
    autoEnable = true; # Auto-theme all supported applications
    
    # Dynamic theme selection
    base16Scheme = selectedTheme.base16Scheme;
    
    # Wallpaper with fallback
    image = if builtins.pathExists selectedTheme.wallpaper
            then selectedTheme.wallpaper
            else "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png";
    
    polarity = selectedTheme.polarity;
    
    # Centralized font configuration
    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      
      # Global font sizes
      sizes = {
        applications = 11;
        desktop = 10;
        popups = 11;
        terminal = 12;
      };
    };
    
    # Global opacity settings
    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.95;
      terminal = 0.90;
    };
    
    # Centralized cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    
    # Enable for ALL applications (Stylix will handle them automatically)
    targets = {
      # Terminal applications
      kitty.enable = true;
      alacritty.enable = true;
      
      # Desktop environment
      hyprland.enable = true;
      hyprlock.enable = false; # Custom wallpaper configured
      waybar.enable = true;
      rofi.enable = true; # Custom theme configured
      
      # Browsers
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
      
      # Development tools
      neovim.enable = true;
      vscode.enable = true;
      
      # System applications
      gtk.enable = true;
      # qt.enable = true;
      
      # Terminal tools
      fzf.enable = true;
      tmux.enable = true;
      btop.enable = false; # Custom theme configured
      
      # Notifications - disabled due to custom theming
      dunst.enable = false;
      
      # Other applications Stylix can theme
      zathura.enable = true;
      
      # Disable only for applications with special requirements
      spicetify.enable = false; # Has its own theme system
    };
  };
  
  # Expose theme colors for custom applications
  home.sessionVariables = {
    # Make base16 colors available to all applications
    BASE16_THEME = currentTheme;
    THEME_MODE = selectedTheme.polarity;
  };
}
