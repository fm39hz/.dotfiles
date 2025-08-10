# Alternative centralized theming with Catppuccin
# Enable this instead of stylix.nix for Catppuccin theming
{ pkgs, inputs, ... }:
{
  # This would require adding catppuccin flake to inputs
  # inputs.catppuccin.url = "github:catppuccin/nix";
  
  # Catppuccin provides modules for many applications
  catppuccin = {
    enable = true;
    flavor = "mocha"; # latte, frappe, macchiato, mocha
    accent = "green"; # rosewater, flamingo, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, blue, lavender
  };

  # Individual application theming
  programs = {
    # Terminal applications
    kitty.catppuccin.enable = true;
    btop.catppuccin.enable = true;
    
    # Development tools
    neovim.catppuccin.enable = true;
    
    # Desktop applications
    rofi.catppuccin.enable = true;
    
    # Other applications
    zathura.catppuccin.enable = true;
    fzf.catppuccin.enable = true;
  };

  # Wayland/Desktop theming
  wayland.windowManager.hyprland.catppuccin.enable = true;
  services.dunst.catppuccin.enable = true;
  programs.waybar.catppuccin.enable = true;
  
  # GTK/Qt theming
  gtk.catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
    size = "standard";
    tweaks = [ "rimless" "black" ];
  };

  qt.catppuccin.enable = true;

  # Cursor theme
  home.pointerCursor.catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
  };
}