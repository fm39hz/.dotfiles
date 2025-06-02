# ~/.config/nixos/modules/desktop/xdg.nix
{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.dconf.enable = true; # Required for GTK apps
}
