# ~/.config/nixos/modules/programs/shell.nix
{ pkgs, ... }:
{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
