# ~/.config/nixos/modules/programs/gaming.nix
{ config, lib, pkgs, ... }:
let cfg = config.modules.programs.gaming;
in {
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      steam
      wine
      lutris
    ];
  };
}
