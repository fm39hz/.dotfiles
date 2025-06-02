# ~/.config/nixos/modules/hardware/default.nix (MISSING)
{ ... }:
{
  imports = [
    ./graphics.nix
    ./bluetooth.nix
    ./audio.nix
    ./nvidia.nix
  ];
}
