{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                    # Wayland/wlroots screen capture
      obs-backgroundremoval     # AI background removal
      obs-pipewire-audio-capture # PipeWire audio capture
      obs-vkcapture            # Vulkan capture
      input-overlay            # Show keyboard/mouse inputs
      obs-gstreamer            # GStreamer integration
    ];
  };
}