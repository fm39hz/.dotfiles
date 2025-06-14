{ personal, ... }: {
  wayland.windowManager.hyprland.settings = let
    script-dir = "${personal.homeDir}/.config/scripts";
    specialWorkspace = [ "pad" "chat" "debug" "browser" ];
    workspacesCount = builtins.length specialWorkspace;
    
    # Helper functions to reduce repetition
    mkMovement = dir: key: [
      "$mod, ${key}, movefocus, ${dir}"
      "$mod SHIFT, ${key}, movewindow, ${dir}"
    ];
    
    mkResize = delta: key: "$mod CTRL, ${key}, resizeactive, ${delta}";
    
    # Generate directional bindings
    directionalBinds = builtins.concatLists [
      (mkMovement "l" "left") (mkMovement "l" "H")
      (mkMovement "r" "right") (mkMovement "r" "L") 
      (mkMovement "u" "up") (mkMovement "u" "K")
      (mkMovement "d" "down") (mkMovement "d" "J")
    ];
    
    # Generate resize bindings
    resizeBinds = [
      (mkResize "0 -40" "k") (mkResize "0 40" "j")
      (mkResize "-40 0" "h") (mkResize "40 0" "l")
      (mkResize "0 -10" "up") (mkResize "0 10" "down")
      (mkResize "-10 0" "left") (mkResize "10 0" "right")
    ];
    
    # Generate workspace bindings (1-9)
    workspaceBinds = builtins.concatLists (builtins.genList (i: let
      ws = i + 1;
      in [
        "$mod, code:1${toString i}, split:workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
      ]
    ) 9);
    
    # Generate special workspace bindings
    specialBinds = builtins.concatLists (builtins.genList (i: let
      ws = builtins.elemAt specialWorkspace i;
      key = builtins.substring 0 1 ws;
      in [
        "$mod, ${key}, togglespecialworkspace, ${ws}"
        "$mod SHIFT, ${key}, split:movetoworkspace, special:${ws}"
      ]
    ) workspacesCount);
    
  in {
    # Variables
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
      # Core bindings
      "$mod, RETURN, exec, $terminal"
      "$mod, BACKSPACE, killactive,"
      "$mod SHIFT, BACKSPACE, exec, hyprctl kill"
      "$mod SHIFT, ESCAPE, exec, $terminalCli btop"
      "$mod, F, togglefloating,"
      "$mod SHIFT, F, fullscreen,"
      "$mod, SPACE, exec, rofi -show drun -run-command 'app2unit {cmd}'"
      
      # Screenshots
      ", PRINT, exec, app2unit hyprshot -m output -o $hyprShotDir"
      "SHIFT, PRINT, exec, app2unit hyprshot -m region -o $hyprShotDir"
      "$mod, PRINT, exec, app2unit hyprshot -m window -o $hyprShotDir"
      
      # System
      "$mod, ESCAPE, exec, pidof wlogout || app2unit wlogout"
      "ALT, ESCAPE, exec, app2unit hyprpanel toggleWindow dashboardmenu"
      "$mod, S, exec, $bar"
      "$mod CTRL, U, exec, $terminalCli $updater"
      "$mod SHIFT, V, exec, python $volumeOutput"
      
      # Window management
      "$mod, M, split:swapactiveworkspaces, current +1"
      "$mod, G, split:grabroguewindows"
      
      # Applications
      "$mod SHIFT, F12, exec, $browser"
      "$mod SHIFT, F11, exec, $telegram"
      
      # Workspace navigation
      "$mod ALT, L, split:workspace, e+1"
      "$mod ALT, H, split:workspace, e-1"
      "$mod, mouse_left, split:workspace, e-1"
      "$mod, mouse_right, split:workspace, e+1"
      "$mod SHIFT CTRL, H, split:workspace, e-1"
      "$mod SHIFT CTRL, L, split:workspace, e+1"
    ] 
    ++ directionalBinds 
    ++ resizeBinds 
    ++ workspaceBinds 
    ++ specialBinds;
    
    binde = [
      ", XF86AudioRaiseVolume, exec, $volume +1%"
      ", XF86AudioLowerVolume, exec, $volume -1%"
    ];
    
    bindl = [
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", switch:on:Lid Switch, exec, app2unit hyprlock"
    ];
    
    bindel = [
      ",XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10"
      ",XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10"
    ];
    
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
