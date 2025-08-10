{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [
          "hyprland/window"
        ];
        
        modules-center = [
          "hyprland/workspaces"
        ];
        
        modules-right = [
          "custom/notification"
          "tray"
          "group/hardware"
          "battery"
          "clock"
        ];

        # Module configurations
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
          };
          persistent_workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          format = " {}";
          separate-outputs = true;
          max-length = 50;
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory" 
            "temperature"
          ];
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
          interval = 1;
        };

        memory = {
          format = " {}%";
          tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G";
          interval = 1;
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
        };

        clock = {
          timezone = "Asia/Ho_Chi_Minh";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M}";
          format-alt = " {:%A, %B %d, %Y}";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace;
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(43, 48, 59, 0.5);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #d3c6aa;
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #a7c080;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
        background-color: #83c092;
        color: #2d353b;
      }

      #workspaces button.urgent {
        background-color: #e67e80;
      }

      #mode {
        background-color: #83c092;
        border-bottom: 3px solid #a7c080;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #tray,
      #mode,
      #idle_inhibitor,
      #window {
        padding: 0 10px;
        color: #d3c6aa;
      }

      #window {
        color: #83c092;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        background-color: #e67e80;
        color: #2d353b;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      label:focus {
        background-color: #000000;
      }

      #cpu {
        background-color: #7fbbb3;
        color: #2d353b;
      }

      #memory {
        background-color: #dbbc7f;
        color: #2d353b;
      }

      #temperature {
        background-color: #e69875;
        color: #2d353b;
      }

      #temperature.critical {
        background-color: #e67e80;
      }

      #tray {
        background-color: #d699b6;
        color: #2d353b;
      }

      #clock {
        background-color: #a7c080;
        color: #2d353b;
      }

      #battery {
        background-color: #83c092;
        color: #2d353b;
      }

      #battery.charging, #battery.plugged {
        color: #2d353b;
        background-color: #a7c080;
      }

      #battery.warning:not(.charging) {
        background-color: #dbbc7f;
        color: #2d353b;
      }

      tooltip {
        background: #2d353b;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #83c092;
      }

      tooltip label{
        color: #d3c6aa;
      }
    '';
  };
}