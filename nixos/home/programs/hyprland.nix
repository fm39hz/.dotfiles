# ~/.config/nixos/home/programs/hyprland.nix
{ inputs, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    
    # Safe plugin loading
    plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      hyprexpo
    ] ++ lib.optionals 
      (inputs ? hyprsplit && inputs.hyprsplit ? packages.${pkgs.system}) 
      [ inputs.hyprsplit.packages.${pkgs.system}.hyprsplit ];
    
    # Let your existing hyprland.conf handle configuration
    # This enables NixOS integration without overriding your configs
  };

  # Hyprland related packages
  home.packages = with pkgs; [
    hyprpaper
    hyprlock 
    hypridle
    hyprpicker
    hyprshot
    
    # Waybar and rofi
    waybar
    rofi-wayland
    
    # Notifications
    dunst
    libnotify
    
    # Screen tools
    grim
    slurp
    wl-clipboard
    
    # Theme tools
    nwg-look
    
    # System monitoring
    brightnessctl
  ];
}
