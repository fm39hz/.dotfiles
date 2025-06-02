# ~/.config/nixos/modules/services/default.nix
{ ... }:
{
  imports = [
    ./greetd.nix
    ./keyd.nix
    ./docker.nix
    ./system.nix
  ];
}
