{
  pkgs,
  personal,
  ...
}:
{
  imports = [
    ./keybinds.nix
  ];
  home.packages = with pkgs; [
    ghostty
    kitty
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hyprlandPlugins.xtra-dispatchers
      hyprlandPlugins.hyprsplit
      hyprlandPlugins.hyprspace
    ];
    settings = let
      configDir = "${personal.homeDir}/.config/hypr/conf";
      font-family = "JetBrains Mono";
    in {
      source = [
      "${configDir}/auto.conf"
      "${configDir}/animations.conf"
      "${configDir}/environment.conf"
      "${configDir}/monitor.conf"
      "${configDir}/style.conf"
      # "${configDir}/mapping.conf"
      "${configDir}/input.conf"
      "${configDir}/rules/rules.conf"
      "${configDir}/plugins.conf"
      ];
    };
  };
}
