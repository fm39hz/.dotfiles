{
  description = "FM39hz's Nix flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
    }: let
      inputs = self.inputs;
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      # User's specific information
      personal = {
        city = "Hanoi";
        user = "fm39hz";
        hostname = "fm39hz-desktop";
        timeZone = "Asia/Ho_Chi_Minh";
        defaultLocale = "en_US.UTF-8";
        homeDir = "/${if system == "aarch-darwin64" then "Users" else "home"}/${personal.user}";
      };
      pkgs = import nixpkgs { inherit system; };
    in {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common.default = ["gtk"];
          hyprland.default = [
            "gtk"
            "hyprland"
          ];
        };

        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
      homeConfigurations = {
        ${personal.hostname} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit personal; inherit inputs; };
          modules = [
            stylix.homeModules.stylix
            ./home.nix
          ];
        };
      };
    };
}
