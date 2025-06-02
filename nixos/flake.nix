{
  description = "EverLand";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland";
    
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... } @ inputs: {
    nixosConfigurations.fm39hz-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/fm39hz-desktop
        ./modules
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fm39hz = import ./home;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
