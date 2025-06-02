# ~/.config/nixos/modules/default.nix
{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./core
    ./desktop
    ./hardware
    ./programs
    ./services
    ./themes
  ];

  options.modules = with lib; {
    desktop.hyprland.enable = mkEnableOption "Hyprland desktop environment";
    hardware.graphics.enable = mkEnableOption "Graphics drivers and tools";
    hardware.bluetooth.enable = mkEnableOption "Bluetooth support";
    hardware.nvidia.enable = mkEnableOption "Nvidia support";
    programs.gaming.enable = mkEnableOption "Gaming programs and Steam";
    programs.development.enable = mkEnableOption "Development tools and languages";
    programs.media.enable = mkEnableOption "Media creation tools";
    services.docker.enable = mkEnableOption "Docker containerization";
    services.greetd.enable = mkEnableOption "greetd login manager";
    services.keyd.enable = mkEnableOption "keyd key remapping";
    themes.everforest.enable = mkEnableOption "Everforest theme";
  };

  config = {
    # Enable envfs for script compatibility
    services.envfs.enable = true;

    # Essential environment variables
    environment.sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet/";
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      MOZ_ENABLE_WAYLAND = "1";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "everforest-cursors";
      HYPRCURSOR_SIZE = "32";
      WLR_NO_HARDWARE_CURSORS = "1";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };

    # Essential system packages
    environment.systemPackages = with pkgs; [
      # Core utilities
      wget curl git vim nano
      
      # Wayland/Hyprland essentials
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      polkit_gnome
      
      # Graphics drivers
      intel-media-driver intel-vaapi-driver
      vulkan-tools vulkan-headers
      
      # Qt/GTK Wayland support
      qt5.qtwayland qt6.qtwayland
      gtk3 gtk4
      
      # Input method
      fcitx5 fcitx5-configtool fcitx5-bamboo
      
      # Audio
      pipewire wireplumber pavucontrol
    ];

    # XDG Portal configuration
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk 
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    # Security
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    # Services
    services = {
      dconf.enable = true;
      gnome.gnome-keyring.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
    };
  };
}
