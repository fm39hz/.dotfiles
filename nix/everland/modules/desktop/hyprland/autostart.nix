{ pkgs, personal, ... }: {
  wayland.windowManager.hyprland.settings = {
    # Autostart applications - UWSM handles systemd integration automatically
    exec-once = [
      # Core Hyprland services
      "hyprpm reload"
      "brightnessctl --restore"
      
      # UI components  
      "hyprpanel"  # If available, otherwise use waybar
      # "waybar"  # Fallback if hyprpanel not available
      "hyprpaper"
      "hypridle"
      "hyprsunset"
      
      # Session management - UWSM handles most of this automatically
      "lxsession"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "/usr/libexec/polkit-gnome-authentication-agent-1"
      
      # Terminal and applications  
      "tmux"
      "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      
      # Hardware support
      "solaar --window=hide" # Logitech devices
      "fcitx5" # Vietnamese input
      
      # Applications
      "steam -silent" # UWSM handles session management, no need for mangohud prefix here
      "localsend --hidden"
      
      # Theming
      "hyprctl setcursor everforest-cursors 32"
      
      # Note: hyprlock handled by hypridle, not needed in autostart
    ];
  };
}