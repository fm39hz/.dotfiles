{
  description = "FM39hz's Nix flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager }: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations = {
        fm39hz-desktop = home-manager.lib.homeManagerConfiguration {
          inherit system;
          pkgs = pkgs;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
