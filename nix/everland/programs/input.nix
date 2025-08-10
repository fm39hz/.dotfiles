{ pkgs, ... }:

{
  # Input method configuration - commented out due to package collision
  # Will need to be configured at system level in configuration.nix
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-bamboo      # Vietnamese input
  #     fcitx5-gtk         # GTK support
  #     libsForQt5.fcitx5-qt # Qt support
  #   ];
  # };

  # Additional input/clipboard packages
  home.packages = with pkgs; [
    xclip            # X11 clipboard utility
    libnotify        # Desktop notifications
    # Vietnamese input packages - install manually for now
    fcitx5-bamboo
    fcitx5-gtk
    libsForQt5.fcitx5-qt
    fcitx5-configtool
  ];

  # Environment variables for input method
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}