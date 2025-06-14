{ personal, pkgs, ...}:
{
  programs.home-manager.enable = true;
  imports = [
    ./modules/desktop
    # ./programs
  ];

  home = {
    packages = with pkgs; [
      lazygit
      lazydocker
    ];

    username = "${personal.user}";
    homeDirectory = "${personal.homeDir}";

    # WARN: NEVER Change this value
    stateVersion = "25.05";
  };
}
