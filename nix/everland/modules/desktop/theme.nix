# Centralized theme management for everforest
# Change currentTheme to switch between themes
{ personal, pkgs, lib, ... }:
let
  # Current theme selection - change this to switch themes
  currentTheme = "everforest";
  
  # Theme definitions
  themes = {
    everforest = {
      name = "Everforest";
      colors = {
        background = "#2d353b";
        foreground = "#d3c6aa";
        primary = "#a7c080";     # Green
        secondary = "#83c092";   # Aqua  
        accent = "#e69875";      # Orange
        warning = "#dbbc7f";     # Yellow
        error = "#e67e80";       # Red
        info = "#7fbbb3";        # Blue
        surface = "#3d484d";
        overlay = "#475258";
      };
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/ForestStairCase.png";
      cursorTheme = "Bibata-Modern-Classic";
      cursorSize = 24;
      fonts = {
        mono = "JetBrainsMono Nerd Font";
        sans = "Noto Sans";
        serif = "Noto Serif";
        emoji = "Noto Color Emoji";
      };
    };
    
    catppuccin = {
      name = "Catppuccin Mocha";
      colors = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        primary = "#a6e3a1";     # Green
        secondary = "#89dceb";   # Sky
        accent = "#f38ba8";      # Pink
        warning = "#f9e2af";     # Yellow
        error = "#f38ba8";       # Pink
        info = "#89b4fa";        # Blue
        surface = "#313244";
        overlay = "#45475a";
      };
      wallpaper = "${personal.homeDir}/Pictures/Wallpaper/catppuccin.png";
      cursorTheme = "Bibata-Modern-Classic";
      cursorSize = 24;
      fonts = {
        mono = "JetBrainsMono Nerd Font";
        sans = "Noto Sans";
        serif = "Noto Serif";
        emoji = "Noto Color Emoji";
      };
    };
  };
  
  selectedTheme = themes.${currentTheme};
in
{
  # Export theme variables for all modules to use
  home.sessionVariables = {
    # Theme identification
    CURRENT_THEME = currentTheme;
    THEME_NAME = selectedTheme.name;
    
    # Color palette
    THEME_BG = selectedTheme.colors.background;
    THEME_FG = selectedTheme.colors.foreground;
    THEME_PRIMARY = selectedTheme.colors.primary;
    THEME_SECONDARY = selectedTheme.colors.secondary;
    THEME_ACCENT = selectedTheme.colors.accent;
    THEME_WARNING = selectedTheme.colors.warning;
    THEME_ERROR = selectedTheme.colors.error;
    THEME_INFO = selectedTheme.colors.info;
    THEME_SURFACE = selectedTheme.colors.surface;
    THEME_OVERLAY = selectedTheme.colors.overlay;
    
    # Fonts
    THEME_FONT_MONO = selectedTheme.fonts.mono;
    THEME_FONT_SANS = selectedTheme.fonts.sans;
    THEME_FONT_SERIF = selectedTheme.fonts.serif;
    THEME_FONT_EMOJI = selectedTheme.fonts.emoji;
    
    # Assets
    THEME_WALLPAPER = selectedTheme.wallpaper;
    THEME_CURSOR = selectedTheme.cursorTheme;
    THEME_CURSOR_SIZE = toString selectedTheme.cursorSize;
  };

  # Global cursor theme
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = selectedTheme.cursorTheme;
    size = selectedTheme.cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };
  
  # Wallpaper (using hyprpaper if available)
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${if builtins.pathExists selectedTheme.wallpaper 
               then selectedTheme.wallpaper 
               else "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png"}
    wallpaper = ,${if builtins.pathExists selectedTheme.wallpaper 
                   then selectedTheme.wallpaper 
                   else "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png"}
    splash = false
  '';
  
  # Enable font packages
  home.packages = with pkgs; [
    # Fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    
    # Cursor themes
    bibata-cursors
  ];
  
  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ selectedTheme.fonts.mono ];
      sansSerif = [ selectedTheme.fonts.sans ];
      serif = [ selectedTheme.fonts.serif ];
      emoji = [ selectedTheme.fonts.emoji ];
    };
  };

  # Documentation comment for theme switching
  home.file.".config/nix/THEME_README.md".text = ''
    # Theme Management
    
    ## Current Theme: ${selectedTheme.name}
    
    ## Available Themes:
    ${lib.concatStringsSep "\n" (map (theme: "- ${theme}") (builtins.attrNames themes))}
    
    ## How to Switch Themes:
    1. Edit `modules/desktop/theme.nix`
    2. Change the `currentTheme` variable to your desired theme
    3. Run `make build` to apply changes
    
    ## Color Palette (${currentTheme}):
    - Background: ${selectedTheme.colors.background}
    - Foreground: ${selectedTheme.colors.foreground} 
    - Primary: ${selectedTheme.colors.primary}
    - Secondary: ${selectedTheme.colors.secondary}
    - Accent: ${selectedTheme.colors.accent}
    
    ## Environment Variables Available:
    All theme colors and settings are exported as environment variables with THEME_ prefix
    for use in custom configurations and scripts.
  '';
}