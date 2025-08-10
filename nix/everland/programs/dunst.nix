{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        
        # Geometry
        width = 350;
        height = 100;
        origin = "top-right";
        offset = "12x12";
        scale = 0;
        notification_limit = 0;
        
        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # Visual
        transparency = 0;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#83c092";
        separator_color = "frame";
        sort = true;
        
        # Font
        font = "JetBrains Mono 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        # Icons
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        icon_path = "/usr/share/icons/Papirus/16x16/status/:/usr/share/icons/Papirus/16x16/devices/:/usr/share/icons/Papirus/16x16/apps/";
        
        # History
        sticky_history = true;
        history_length = 20;
        
        # Misc/Advanced
        dmenu = "${pkgs.rofi-wayland}/bin/rofi -dmenu -p dunst:";
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 8;
        ignore_dbusclose = false;
        
        # Wayland
        force_xwayland = false;
        
        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      experimental = {
        per_monitor_dpi = false;
      };
      
      urgency_low = {
        background = "#2d353b";
        foreground = "#d3c6aa";
        frame_color = "#83c092";
        timeout = 5;
        # Icon for low urgency
        default_icon = "dialog-information";
      };
      
      urgency_normal = {
        background = "#2d353b";
        foreground = "#d3c6aa";
        frame_color = "#a7c080";
        timeout = 10;
        # Icon for normal urgency
        default_icon = "dialog-information";
      };
      
      urgency_critical = {
        background = "#2d353b";
        foreground = "#d3c6aa";
        frame_color = "#e67e80";
        timeout = 0;
        # Icon for critical urgency
        default_icon = "dialog-error";
      };
      
      # Custom rules
      "app-name=Volume" = {
        urgency = "low";
        timeout = 2;
        frame_color = "#7fbbb3";
      };
      
      "app-name=Brightness" = {
        urgency = "low";
        timeout = 2;
        frame_color = "#dbbc7f";
      };
      
      "summary=*Screenshot*" = {
        timeout = 3;
        frame_color = "#d699b6";
      };
    };
  };
}