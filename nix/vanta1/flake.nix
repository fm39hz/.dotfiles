{
  description = "EverLand starting point";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsunset.url = "github:hyprwm/hyprsunset";
    sherlock.url = "github:Skxxtz/sherlock";
    waybar.url = "github:alexays/waybar";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    ## set these for yourself please!!!
    system = "x86_64-linux";
    personal = {
      user = "fm39hz";
      hostname = "fm39hz";
      timeZone = "Asia/Ho_Chi_Minh";
      default-locale = "en_US.UTF-8";
      city = "Hanoi";
      cursor-size = 24;
    };
    ## other
    unstable-overlay = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        # needed to install obsidian ugh
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
        input-fonts.acceptLicense = true; # license for input-fonts: https://input.djr.com/license/. go support it's creator here!!: http://input.djr.com/buy
      };
      overlays = [
        unstable-overlay
      ];
    };
    args = {inherit inputs personal pkgs;};
  in {
    nixosConfigurations = {
      fm39hz = nixpkgs.lib.nixosSystem {
        system = "${system}";

        # special args sent to configuration.nix
        specialArgs = args;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            # 'extra'? special args sent to home/default.nix (and all modules it includes)
            home-manager.extraSpecialArgs = args;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${personal.user} = import ./home;
          }
          # not technically my laptop's exact model, but close enough
          #nixos-hardware.nixosModules.dell-xps-13-9310
        ];
      };
    };
  };
}
