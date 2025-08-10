{ personal, pkgs, ...}:
{
  programs.home-manager.enable = true;
  imports = [
    ./modules/desktop
    ./programs
  ];

  # All program configurations moved to ./programs/ modules

  home = {
    # Remaining packages not handled by program modules
    packages = with pkgs; [
      # Containerization - docker service enabled in system config
      docker-buildx
      docker-compose
    ];

    username = "${personal.user}";
    homeDirectory = "${personal.homeDir}";

    # WARN: NEVER Change this value
    stateVersion = "25.05";
  };

  # Spicetify configuration moved to media module
}
