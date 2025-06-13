# ~/.config/nixos/modules/services/system.nix
{ pkgs, ... }:
{
  services = {
    power-profiles-daemon.enable = true;
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
    fprintd.enable = true;
  };
}
