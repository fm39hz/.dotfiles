{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./keybinds.nix
  ];
  home.packages = with pkgs; [
    ghostty
    kitty
    inputs.hyprsunset.packages.${system}.hyprsunset
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hyprlandPlugins.xtra-dispatchers
      hyprlandPlugins.hyprsplit
      hyprlandPlugins.Hyprspace
    ];
    settings = let
      font-family = "JetBrains Mono";
    in {
      
    };
  };
}
