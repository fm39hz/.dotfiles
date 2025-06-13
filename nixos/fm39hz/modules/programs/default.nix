# ~/.config/nixos/modules/programs/default.nix
{ ... }:
{
  imports = [
    ./gaming.nix
    ./development.nix
    ./media.nix
    ./shell.nix
  ];
}
