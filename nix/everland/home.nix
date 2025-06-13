{ personal, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      home-manager
    ];

    username = "${personal.user}";
    homeDirectory = "/home/${personal.user}";

    # NOTE: NEVER Change this value
    stateVersion = "23.11";
  };
}
