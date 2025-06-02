# ~/.config/nixos/home/programs/hyprland.nix - Integrate with existing config
{ inputs, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    
    # Safe plugin loading
    plugins = lib.optionals 
      (inputs ? hyprland-plugins && inputs.hyprland-plugins ? packages.${pkgs.system}) 
      [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo ];
    
    # Let your existing hyprland.conf handle the configuration
    # This just enables the NixOS integration
  };
}
