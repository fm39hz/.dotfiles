{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    mappings = {
      # Vim-like navigation
      "h" = "scroll left";
      "j" = "scroll down";
      "k" = "scroll up";
      "l" = "scroll right";
      
      # Page navigation
      "J" = "navigate next";
      "K" = "navigate previous";
      
      # Zoom
      "+" = "zoom in";
      "-" = "zoom out";
      "=" = "zoom in";
      
      # Fit
      "w" = "adjust_window width";
      "e" = "adjust_window best-fit";
      
      # Rotation
      "r" = "rotate rotate_ccw";
      "R" = "rotate rotate_cw";
      
      # Toggle
      "d" = "toggle_page_mode";
      "i" = "recolor";
    };
  };
}
