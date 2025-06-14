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

  outputs = { nixpkgs, home-manager, stylix, ... }: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      # User's specific information
      personal = {
        city = "Hanoi";
        user = "fm39hz";
        hostname = "fm39hz-desktop";
        timeZone = "Asia/Ho_Chi_Minh";
        defaultLocale = "en_US.UTF-8";
        homeDir = "${if system == "aarch-darwin64" then "/Users" else "/home"}/${personal.user}";
      };
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations = {
        ${personal.hostname} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit personal; };
          modules = [
            stylix.homeModules.stylix
            ./home.nix
          ];
        };
      };
    };
}
