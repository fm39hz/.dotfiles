# ~/.config/nixos/modules/hardware/bluetooth.nix (MISSING)
{ config, lib, ... }:
let cfg = config.modules.hardware.bluetooth;
in {
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
