{ lib, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "fm39hz";
    homeDirectory = "/home/fm39hz";

    stateVersion = "23.11";
  };
}
