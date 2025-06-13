# ~/.config/nixos/modules/desktop/default.nix
{ ... }:
{
  imports = [
    ./hyprland.nix
    ./fonts.nix
    ./audio.nix
    ./xdg.nix
  ];
}
