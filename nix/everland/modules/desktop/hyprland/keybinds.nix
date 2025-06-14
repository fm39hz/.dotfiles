{ personal, ... }: {
  wayland.windowManager.hyprland.settings = let
    script-dir = "${personal.homeDir}/.config/scripts";
    specialWorkspace = [ "pad" "chat" "debug" "browser" ];
    workspacesCount = builtins.length specialWorkspace;
  in {
      "$mod" = "SUPER";
      "$terminalCli" = "app2unit kitty";
      "$terminal" = "app2unit ghostty";
      "$browser" = "${script-dir}/browser.sh";
      "$telegram" = "${script-dir}/telegram.sh";
      "$volumeOutput" = "${script-dir}/volume.py";
      "$bar" = "${script-dir}/hyprpanel.sh";
      "$updater" = "${script-dir}/system_update.sh";
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
        "$mod CTRL, U, exec, $terminalCli $updater"
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
        "$mod ALT, L, split:workspace, e+1"
        "$mod ALT, H, split:workspace, e-1"
        "$mod, mouse_left, split:workspace, e-1"
        "$mod, mouse_right, split:workspace, e+1"
        "$mod SHIFT CTRL, H, split:workspace, e-1"
        "$mod SHIFT CTRL, L, split:workspace, e+1"
      ]++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, split:workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
            ]
          )
        9)
      ) ++ (
        # binds $mod + [shift +] {first letter of special workspaces} to [move to] special workspace
        builtins.concatLists (builtins.genList (i: let
            ws = builtins.elemAt specialWorkspace i;
            in [
              "$mod, ${builtins.substring 0 1 ws}, togglespecialworkspace, ${ws}"
              "$mod SHIFT, ${builtins.substring 0 1 ws}, split:movetoworkspace, special:${ws}"
            ]
          )
        workspacesCount)
      );
      binde = [
        ", XF86AudioRaiseVolume, exec, $volume +1% # Increase volume by 5%"
        ", XF86AudioLowerVolume, exec, $volume -1% # Reduce volume by 5%"
      ];
      bindl = [
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", switch:on:Lid Switch, exec, app2unit hyprlock"
      ];
      bindel = [
        ",XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10"
        ",XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10"
      ];
      bindm= [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
  };
}
