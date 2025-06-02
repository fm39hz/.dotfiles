# ~/.config/nixos/modules/hardware/graphics.nix (MISSING)
{ config, lib, pkgs, ... }:
let cfg = config.modules.hardware.graphics;
in {
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-utils
        vulkan-loader
        vulkan-validation-layers
      ];
    };
  };
}
