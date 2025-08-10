# Properly configured Stylix - hybrid approach with custom themes
{ personal, pkgs, lib, config, ... }:
let
  # Use your existing theme system
  currentTheme = "everforest";
  
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
  };
  
  selectedTheme = themes.${currentTheme};
in
{
  stylix = {
    enable = true;
    autoEnable = false;  # CRITICAL: Prevents automatic theming conflicts
    
    # Use your centralized theme
    base16Scheme = selectedTheme.base16Scheme;
    image = if builtins.pathExists selectedTheme.wallpaper
            then selectedTheme.wallpaper
            else "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png";
    polarity = selectedTheme.polarity;
    
    # Your excellent font configuration
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
      
      sizes = {
        applications = 11;
        desktop = 10;
        popups = 11;
        terminal = 12;
      };
    };
    
    # Global settings
    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.95;
      terminal = 0.90;
    };
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    
    # SELECTIVE TARGETING - Based on Stylix strengths vs your custom configs
    targets = {
      # ✅ Stylix excels at these
      gtk.enable = true;                    # Good at system theming
      qt.enable = true;                     # Good at system theming  
      neovim.enable = true;                 # Excellent Base16 + transparency
      firefox = {                           # Adds visual theming you lack
        enable = true;
        profileNames = [ "default" ];
      };
      btop.enable = true;                   # You have no custom config, Stylix is good
      tmux.enable = true;                   # Simple terminal theming
      fzf.enable = true;                    # Simple color application
      zathura.enable = true;                # PDF reader theming
      
      # 🎯 Mixed approach - Stylix colors + your functionality  
      kitty = {                             # Let Stylix handle colors, keep your keybinds
        enable = true;
        variant256Colors = true;            # Better color accuracy
      };
      alacritty.enable = true;              # Good terminal integration
      vscode.enable = true;                 # IDE theming
      
      # ❌ Your custom themes are far superior
      rofi.enable = false;                  # Your 200+ line theme with animations
      dunst.enable = false;                 # Your custom urgency rules + progress bars  
      waybar.enable = false;                # Your 270+ line styling with modules
      hyprlock.enable = false;              # Your blur effects and positioning
      spicetify.enable = false;             # Has its own theme system
    };
  };

  # Make Stylix colors available to custom applications
  home.sessionVariables = lib.mkMerge [
    {
      # Your existing theme variables
      CURRENT_THEME = currentTheme;
      BASE16_THEME = currentTheme;
    }
    # Add Stylix colors for custom themes to use
    (lib.optionalAttrs (config ? lib.stylix.colors) (
      lib.mapAttrs' 
        (name: value: lib.nameValuePair "STYLIX_${lib.toUpper name}" "#${value}")
        config.lib.stylix.colors
    ))
  ];

  # Export color palette for scripts and custom configs
  home.file.".config/stylix/colors.conf".text = lib.optionalString (config ? lib.stylix.colors) ''
    # Stylix Base16 Colors - ${currentTheme}
    base00=${config.lib.stylix.colors.base00}  # background
    base01=${config.lib.stylix.colors.base01}  # lighter background
    base02=${config.lib.stylix.colors.base02}  # selection background
    base03=${config.lib.stylix.colors.base03}  # comments
    base04=${config.lib.stylix.colors.base04}  # dark foreground
    base05=${config.lib.stylix.colors.base05}  # foreground
    base06=${config.lib.stylix.colors.base06}  # light foreground
    base07=${config.lib.stylix.colors.base07}  # lightest foreground
    base08=${config.lib.stylix.colors.base08}  # red
    base09=${config.lib.stylix.colors.base09}  # orange
    base0A=${config.lib.stylix.colors.base0A}  # yellow
    base0B=${config.lib.stylix.colors.base0B}  # green
    base0C=${config.lib.stylix.colors.base0C}  # cyan
    base0D=${config.lib.stylix.colors.base0D}  # blue
    base0E=${config.lib.stylix.colors.base0E}  # purple
    base0F=${config.lib.stylix.colors.base0F}  # brown
  '';
}