# ~/.config/nixos/modules/programs/media.nix - ENHANCED
{ config, lib, pkgs, ... }:
let cfg = config.modules.programs.media;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Video/Audio editing
      vlc obs-studio ffmpeg sox
      
      # Image editing
      gimp imagemagick chafa
      
      # 3D modeling
      blender
      
      # Media players
      mpd
      
      # Thumbnails
      ffmpegthumbnailer
      
      # Screen recording (if available)
      # gpu-screen-recorder # Not in nixpkgs
      
      # Image viewers
      # nsxiv # Check if available
    ];
  };
}
