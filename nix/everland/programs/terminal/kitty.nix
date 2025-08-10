{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      # Everforest theme colors
      background = "#2d353b";
      foreground = "#d3c6aa";
      selection_background = "#475258";
      selection_foreground = "#d3c6aa";
      cursor = "#d3c6aa";
      cursor_text_color = "#2d353b";
      
      # Normal colors
      color0 = "#475258";
      color1 = "#e67e80";
      color2 = "#a7c080";
      color3 = "#dbbc7f";
      color4 = "#7fbbb3";
      color5 = "#d699b6";
      color6 = "#83c092";
      color7 = "#d3c6aa";
      
      # Bright colors
      color8 = "#475258";
      color9 = "#e67e80";
      color10 = "#a7c080";
      color11 = "#dbbc7f";
      color12 = "#7fbbb3";
      color13 = "#d699b6";
      color14 = "#83c092";
      color15 = "#d3c6aa";
      
      # Window settings
      window_padding_width = 8;
      window_margin_width = 0;
      single_window_margin_width = -1;
      window_border_width = "1pt";
      draw_minimal_borders = true;
      
      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = "0.0";
      
      # Mouse
      mouse_hide_wait = "3.0";
      url_color = "#83c092";
      url_style = "curly";
      open_url_modifiers = "kitty_mod";
      open_url_with = "default";
      copy_on_select = false;
      
      # Terminal bell
      bell_on_tab = true;
      
      # Advanced
      shell = "fish";
      editor = "nvim";
      close_on_child_death = false;
      allow_remote_control = false;
      listen_on = "none";
      update_check_interval = 0;
      startup_session = "none";
      clipboard_control = "write-clipboard write-primary";
      term = "xterm-kitty";
      
      # OS specific
      linux_display_server = "wayland";
      wayland_titlebar_color = "system";
      
      # Scrollback
      scrollback_lines = 10000;
      wheel_scroll_multiplier = "5.0";
      touch_scroll_multiplier = "1.0";
      
      # Miscellaneous
      confirm_os_window_close = 0;
      
      # Background opacity (commented out for solid background)
      # background_opacity = "0.95";
      # dynamic_background_opacity = true;
    };

    keybindings = {
      # Window management
      "kitty_mod+enter" = "new_window";
      "kitty_mod+n" = "new_os_window";
      "kitty_mod+w" = "close_window";
      "kitty_mod+]" = "next_window";
      "kitty_mod+[" = "previous_window";
      "kitty_mod+f" = "move_window_forward";
      "kitty_mod+b" = "move_window_backward";
      "kitty_mod+`" = "move_window_to_top";
      "kitty_mod+1" = "first_window";
      "kitty_mod+2" = "second_window";
      "kitty_mod+3" = "third_window";
      "kitty_mod+4" = "fourth_window";
      "kitty_mod+5" = "fifth_window";
      "kitty_mod+6" = "sixth_window";
      "kitty_mod+7" = "seventh_window";
      "kitty_mod+8" = "eighth_window";
      "kitty_mod+9" = "ninth_window";
      "kitty_mod+0" = "tenth_window";
      
      # Tab management
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+q" = "close_tab";
      "kitty_mod+l" = "next_layout";
      "kitty_mod+." = "move_tab_forward";
      "kitty_mod+," = "move_tab_backward";
      "kitty_mod+alt+t" = "set_tab_title";
      
      # Font sizes
      "kitty_mod+equal" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+backspace" = "change_font_size all 0";
      
      # Miscellaneous
      "kitty_mod+f10" = "toggle_fullscreen";
      "kitty_mod+u" = "input_unicode_character";
      "kitty_mod+f2" = "edit_config_file";
      "kitty_mod+escape" = "kitty_shell window";
      "kitty_mod+f5" = "load_config_file";
      "kitty_mod+f6" = "debug_config";
      
      # Scrolling
      "kitty_mod+up" = "scroll_line_up";
      "kitty_mod+down" = "scroll_line_down";
      "kitty_mod+k" = "scroll_line_up";
      "kitty_mod+j" = "scroll_line_down";
      "kitty_mod+page_up" = "scroll_page_up";
      "kitty_mod+page_down" = "scroll_page_down";
      "kitty_mod+home" = "scroll_home";
      "kitty_mod+end" = "scroll_end";
      "kitty_mod+h" = "show_scrollback";
    };
  };
}