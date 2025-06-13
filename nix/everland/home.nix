{ personal, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      home-manager
    ];

    username = "${personal.user}";
    homeDirectory = "/${personal.homeDir}/${personal.user}";

    # WARN: NEVER Change this value
    stateVersion = "23.11";
  };
}
