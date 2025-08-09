{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Input configuration from input.conf
    input = {
      kb_layout = "us";
      follow_mouse = 2;
      mouse_refocus = false;
      sensitivity = 0;
      numlock_by_default = true;
      special_fallthrough = true;
      
      touchpad = {
        natural_scroll = true;
      };
    };

    cursor = {
      no_hardware_cursors = true;
    };

    # Workspace swipe gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_distance = 200;
    };

    # Per-device configuration example
    device = [
      {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      }
    ];
  };
}