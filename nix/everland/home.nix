{ personal, pkgs, ...}:
{
  programs.home-manager.enable = true;
  home = {
    packages = with pkgs; [
      lazygit
      lazydocker
    ];

    username = "${personal.user}";
    homeDirectory = "/${personal.homeDir}/${personal.user}";

    # WARN: NEVER Change this value
    stateVersion = "23.11";
  };
}
