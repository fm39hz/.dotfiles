{
  description = "FM39hz's Nix flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
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
        homeDir = if system == "aarch-darwin64" then "/Users" else "/home";
      };
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations = {
        ${personal.hostname} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit personal; };
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
