{
  pkgs,
  personal,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./monitor.nix
    ./animations.nix
    ./decoration.nix
    ./environment.nix
    ./input.nix
    ./autostart.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];
  
  home.packages = with pkgs; [
    # Hyprland ecosystem (packages needed for desktop functionality)
    hyprpaper
    hypridle
    hyprlock
    hyprpicker
    hyprshot
    hyprpolkitagent
    
    # Window management and utilities
    rofi-wayland
    waybar
    wlogout
    
    # System utilities for Hyprland
    brightnessctl
    grim
    slurp
    wl-clipboard
    cliphist
    
    # Session management
    lxsession
    
    # Theme and appearance
    swww # wallpaper daemon alternative
    
    # Hardware support
    solaar # Logitech devices
    
    # Input method (Vietnamese support)
    fcitx5
    fcitx5-configtool
  ];
  
  # Note: Terminal applications (ghostty, kitty) are in main home.nix to avoid duplicates
  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    
    plugins = with pkgs; [
      hyprlandPlugins.xtra-dispatchers
      hyprlandPlugins.hyprsplit
      hyprlandPlugins.hyprspace
    ];
    
    # Basic settings - detailed configs are in separate modules
    settings = let
      configDir = "${personal.homeDir}/.config/hypr/conf";
      font-family = "JetBrains Mono";
    in {
      # Keep sourcing external files for rules and plugins that might be complex
      source = [
        "${configDir}/rules/rules.conf"
        "${configDir}/plugins.conf"
      ];
      
      # Font configuration
      misc.font_family = font-family;
    };
  };
}
