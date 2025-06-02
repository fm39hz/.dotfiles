# ~/.config/nixos/modules/hardware/audio.nix - CRITICAL MISSING FILE
{ config, lib, pkgs, ... }:
let cfg = config.modules.hardware.graphics;  # Uses graphics enable for audio
in {
  config = lib.mkIf cfg.enable {
    # CRITICAL: Audio configuration
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      playerctl
      pamixer
    ];
  };
}

