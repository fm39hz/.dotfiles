{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    theme = {
      "window" = {
        transparency = "real";
        location = "center";
        anchor = "center";
        fullscreen = false;
        width = "600px";
        x-offset = "0px";
        y-offset = "0px";
        
        enabled = true;
        margin = "0px";
        padding = "0px";
        border = "2px solid";
        border-radius = "8px";
        border-color = "@border-color";
        cursor = "default";
      };
      
      "mainbox" = {
        enabled = true;
        spacing = "0px";
        margin = "0px";
        padding = "20px";
        border = "0px solid";
        border-radius = "0px";
        border-color = "@border-color";
        background-color = "transparent";
        children = [ "inputbar" "listview" ];
      };
      
      "inputbar" = {
        enabled = true;
        spacing = "10px";
        margin = "0px 0px 20px 0px";
        padding = "12px";
        border = "1px solid";
        border-radius = "6px";
        border-color = "@border-color";
        background-color = "@bg1";
        children = [ "prompt" "entry" ];
      };
      
      "prompt" = {
        enabled = true;
        background-color = "transparent";
      };
      
      "textbox-prompt-colon" = {
        enabled = true;
        expand = false;
        str = "::";
        background-color = "transparent";
      };
      
      "entry" = {
        enabled = true;
        background-color = "transparent";
        cursor = "text";
        placeholder = "Search...";
        placeholder-color = "inherit";
      };
      
      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        
        spacing = "2px";
        margin = "0px";
        padding = "0px";
        border = "0px solid";
        border-radius = "0px";
        background-color = "transparent";
        text-color = "@text-color";
        cursor = "default";
      };
      
      "scrollbar" = {
        handle-width = "5px";
        border-radius = "8px";
        background-color = "@bg1";
      };
      
      "element" = {
        enabled = true;
        spacing = "10px";
        margin = "0px";
        padding = "8px";
        border = "0px solid";
        border-radius = "4px";
        border-color = "@border-color";
        background-color = "transparent";
        text-color = "@text-color";
        cursor = "pointer";
      };

      "element-text" = {
        vertical-align = "0.5";
        horizontal-align = "0.0";
      };
      
      "mode-switcher" = {
        enabled = true;
        spacing = "10px";
        margin = "0px";
        padding = "0px";
        border = "0px solid";
        border-radius = "0px";
        border-color = "@border-color";
        background-color = "transparent";
        text-color = "@text-color";
      };
      
      "button" = {
        padding = "8px";
        border = "0px solid";
        border-radius = "4px";
        border-color = "@border-color";
        background-color = "@bg1";
        cursor = "pointer";
      };
      
      "message" = {
        enabled = true;
        margin = "0px";
        padding = "0px";
        border = "0px solid";
        border-radius = "0px";
        background-color = "transparent";
        text-color = "@text-color";
      };
      
      "textbox" = {
        padding = "8px";
        border = "0px solid";
        border-radius = "4px";
        border-color = "@border-color";
        background-color = "@bg1";
        vertical-align = "0.5";
        horizontal-align = "0.0";
        highlight = "none";
        placeholder-color = "@text-color";
        blink = true;
        markup = true;
      };
      
      "error-message" = {
        padding = "8px";
        border = "2px solid";
        border-radius = "4px";
        border-color = "@red";
        background-color = "@bg1";
        text-color = "@red";
      };
    };
    
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      icon-theme = "Papirus";
      display-drun = " ";
      display-run = " ";
      display-window = " ";
      display-ssh = " ";
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
      kb-cancel = "Escape,Control+c";
      kb-accept-entry = "Return,KP_Enter";
      kb-row-up = "Up,Control+k,Control+p";
      kb-row-down = "Down,Control+j,Control+n";
      kb-remove-to-eol = "Control+Shift+e";
      kb-remove-char-back = "BackSpace,Shift+BackSpace";
      kb-remove-char-forward = "Delete,Control+d";
    };
  };
}
