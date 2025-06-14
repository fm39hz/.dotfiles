{personal, ...}: {
  wayland.windowManager.hyprland.settings = let
    script-dir = "${personal.homeDir}/.config/hypr/scripts";
  in {
      "$mod" = "SUPER";
      "$terminalCli" = "app2unit kitty";
      "$terminal" = "app2unit ghostty";
      "$browser" = "${script-dir}/browser.sh";
      "$telegram" = "${script-dir}/telegram.sh";
      "$volumeOutput" = "${script-dir}/volume.py";
      "$bar" = "${script-dir}/hyprpanel.sh";
      "$hyprShotDir" = "~/Pictures/ScreenShots";
      "$volume" = "pactl set-sink-volume @DEFAULT_SINK@";
      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod, BACKSPACE, killactive,"
        "$mod SHIFT, BACKSPACE, exec, hyprctl kill"
        "$mod SHIFT, ESCAPE, exec, $terminalCli btop"
        "$mod, F, togglefloating,"
        "$mod SHIFT, F, fullscreen,"
        "$mod, SPACE, exec, rofi -show drun -run-command 'app2unit {cmd}'"
        ", PRINT, exec, app2unit hyprshot -m output -o $hyprShotDir"
        "SHIFT, PRINT, exec, app2unit hyprshot -m region -o $hyprShotDir"
        "$mod, PRINT, exec, app2unit hyprshot -m window -o $hyprShotDir"
        "$mod, ESCAPE, exec, pidof wlogout || app2unit  wlogout"
        "ALT, ESCAPE, exec, app2unit hyprpanel toggleWindow dashboardmenu"
        "$mod, S, exec, $bar"
        "$mod CTRL, U, exec, $terminalCli ~/.config/scripts/system_update.sh"
        "$mod, P, togglespecialworkspace, scratchpad"
        "$mod, C, togglespecialworkspace, chat"
        "$mod, D, togglespecialworkspace, debug"
        "$mod, B, togglespecialworkspace, browser"
        "$mod SHIFT, C, split:movetoworkspace, special:chat"
        "$mod SHIFT, P, split:movetoworkspace, special:scratchpad"
        "$mod SHIFT, D, split:movetoworkspace, special:debug"
        "$mod SHIFT, B, split:movetoworkspace, special:browser"
        "$mod SHIFT, V, exec, python $volumeOutput"
        "$mod, M, split:swapactiveworkspaces, current +1"
        "$mod, G, split:grabroguewindows"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod CTRL, h, resizeactive, -40 0"
        "$mod CTRL, l, resizeactive, 40 0"
        "$mod CTRL, k, resizeactive, 0 -40"
        "$mod CTRL, j, resizeactive, 0 40"
        "$mod CTRL, left, resizeactive, -10 0"
        "$mod CTRL, right, resizeactive, 10 0"
        "$mod CTRL, up, resizeactive, 0 -10"
        "$mod CTRL, down, resizeactive, 0 10"

        # applications
        "$mod SHIFT, F12, exec, $browser"
        "$mod SHIFT, F11, exec, $telegram"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, $volume +1% # Increase volume by 5%"
        ", XF86AudioLowerVolume, exec, $volume -1% # Reduce volume by 5%"
      ];
      bindl = [
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ];
      bindel = [
        ",XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10"
        ",XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10"
      ];
  };
}
