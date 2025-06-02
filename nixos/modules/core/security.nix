# ~/.config/nixos/modules/core/security.nix
{ ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {}; # Required for swaylock
  };
}
