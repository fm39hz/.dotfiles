# ~/.config/nixos/modules/desktop/hyprland.nix - COMPLETE package list
{ config, lib, pkgs, inputs, ... }:
let cfg = config.modules.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };

    # Complete Hyprland ecosystem packages
    environment.systemPackages = with pkgs; [
      # Core Hyprland
      hyprpaper hyprlock hypridle hyprpicker
      
      # UI Components
      waybar rofi-wayland wlogout swww
      dunst libnotify
      
      # Screenshot tools
      grim slurp grimblast
      
      # Clipboard
      wl-clipboard xclip
      
      # Theme tools
      nwg-look gtk3 gtk4 gtk-engine-murrine
      qt5ct qt5.qtwayland kvantum
      
      # File manager
      thunar xfce.thunar-archive-plugin xarchiver
      
      # Network
      networkmanagerapplet
      
      # System info & monitoring
      fastfetch btop powertop
      
      # Session management
      uwsm
      
      # Brightness control
      brightnessctl
      
      # Authentication
      gnome.gnome-keyring lxsession
      
      # AGS for HyprPanel (available in nixpkgs)
      ags
    ];
    
    # Services
    services = {
      greetd.enable = true;
      pipewire.enable = true;
      dconf.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
      fprintd.enable = true;
    };
    
    # XDG portal setup
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk 
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
