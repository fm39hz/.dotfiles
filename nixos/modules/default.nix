# ~/.config/nixos/modules/default.nix - UPDATED with missing options
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
    themes.everforest.enable = mkEnableOption "Everforest theme";
  };

  # Environment variables (keeping existing + adding missing)
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

  environment.systemPackages = with pkgs; [
    wget curl git vim nano
    intel-media-driver intel-vaapi-driver
    polkit_gnome xdg-desktop-portal-gtk
    fcitx5 fcitx5-configtool
  ];
}
