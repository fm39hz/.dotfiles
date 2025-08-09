{ pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration from monitor.conf
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1" # laptop screen
      "DP-1, 1920x1080@170, 0x0, 1, bitdepth, 10" # high refresh rate monitor
      "HDMI-A-1, 1920x1080@60, 1920x0, 1" # secondary monitor positioned to the right
      ", preferred, auto, 1" # fallback for any other monitors
    ];
    
    # Experimental features for color management
    experimental = {
      xx_color_management_v4 = true;
    };
  };
}
