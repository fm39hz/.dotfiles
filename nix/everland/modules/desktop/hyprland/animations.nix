{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Animations configuration from animations.conf
    animations = {
      enabled = true;

      bezier = [
        "smoothDrive, 0.05, 0.9, 0.1, 1.05"
        "overdrive, 0.10, 0.9, 0.1, 1.05"
        "zoomIn, 0.85, 0, 0.15, 1"
      ];

      animation = [
        "windows, 1, 5, smoothDrive"
        "windowsOut, 1, 5, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 5, default"
        "workspaces, 1, 6, overdrive"
        "specialWorkspace, 1, 5, smoothDrive, slidefade"
      ];
    };
  };
}