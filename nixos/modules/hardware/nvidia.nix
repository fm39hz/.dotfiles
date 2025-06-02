# ~/.config/nixos/modules/hardware/nvidia.nix - CRITICAL MISSING FILE
{ config, lib, pkgs, ... }:
let cfg = config.modules.hardware.nvidia;
in {
  config = lib.mkIf cfg.enable {
    # NVIDIA configuration
    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.systemPackages = with pkgs; [
      libva-nvidia-driver
    ];
  };
}
