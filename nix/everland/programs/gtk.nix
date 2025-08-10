{ pkgs, lib, ... }:

{
  # GTK configuration - theme managed by stylix, only set additional preferences
  gtk = {
    enable = true;
    
    # Let stylix handle theme, font, icons, and cursor
    # Only configure additional preferences
    
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-hint-font-metrics = 1;
    };
  };

  # Qt theming to match GTK (force override stylix qt settings)
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "gtk3";
    style = {
      name = lib.mkForce "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Additional theme packages
  home.packages = with pkgs; [
    # Icon themes
    papirus-icon-theme
    adwaita-icon-theme
    
    # Cursor themes  
    bibata-cursors
    
    # GTK themes
    gnome-themes-extra
    adwaita-qt
    
    # Qt theming
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qt6ct
    
    # Font rendering
    fontconfig
  ];

  # XDG settings for consistent theming
  xdg.configFile = {
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=Noto Sans 11
      gtk-icon-theme-name=Papirus-Dark
      gtk-theme-name=Adwaita-dark
    '';
    
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvArcDark
    '';
  };

  # Environment variables for consistent theming
  home.sessionVariables = {
    # Qt theming
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    
    # GTK theming
    GTK_THEME = "Adwaita:dark";
    
    # Cursor theme
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}