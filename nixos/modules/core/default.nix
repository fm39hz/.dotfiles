# ~/.config/nixos/modules/core/default.nix
{ ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
  ];
}
