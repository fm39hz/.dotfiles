# ~/.config/nixos/modules/services/docker.nix
{ config, lib, ... }:
let cfg = config.modules.services.docker;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
