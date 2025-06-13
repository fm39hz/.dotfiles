# ~/.config/nixos/modules/core/networking.nix
{ ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
}
