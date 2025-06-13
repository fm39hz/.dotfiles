{ lib, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      home-manager
    ];

    username = "fm39hz";
    homeDirectory = "/home/fm39hz";

    # NOTE: NEVER Change this value
    stateVersion = "23.11";
  };
}
