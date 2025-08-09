{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Decoration and styling from style.conf
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 0.8;
      
      blur = {
        enabled = true;
        size = 2;
        passes = 3;
        new_optimizations = true;
      };
      
      # Shadow disabled in current config
      # drop_shadow = true;
      # shadow_range = 8;
      # shadow_render_power = 4;
      # "col.shadow" = "rgba(1a1a1aee)";
    };

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(a7c080ff)"; # Everforest green
      "col.inactive_border" = "rgba(3d484dff)"; # Everforest dark
      layout = "dwindle";
      allow_tearing = false;
    };

    # Layout configurations
    dwindle = {
      pseudotile = true;
      force_split = 2;
      preserve_split = true;
    };

    master = {
      mfact = 0.5;
    };

    # Misc settings
    misc = {
      vfr = true;
      vrr = 1;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      "col.splash" = "rgba(a7c080ff)"; # Everforest green
    };
  };
}