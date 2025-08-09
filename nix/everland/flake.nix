{
  description = "FM39hz's Nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Community flakes for additional applications
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    thorium-browser = {
      url = "github:siryoussef/thorium-browser-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    zen-browser,
    thorium-browser, 
    spicetify-nix,
    ghostty,
    ...
    }: let
      system = "x86_64-linux";
      
      # User's specific information
      personal = {
        city = "Hanoi";
        user = "fm39hz";
        hostname = "fm39hz-desktop";
        timeZone = "Asia/Ho_Chi_Minh";
        defaultLocale = "en_US.UTF-8";
        homeDir = "/home/fm39hz";  # Fixed: was referencing itself
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
    };
    in {
      # NixOS system configuration
      nixosConfigurations = {
        ${personal.hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit personal;
            inputs = self.inputs; 
          };
          modules = [
            ./configuration.nix
            {
              programs.hyprland = {
                enable = true;
                withUWSM = true; # Universal Wayland Session Manager - replaces app2unit
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
                extraPortals = with pkgs; [
                  xdg-desktop-portal-gtk
                  xdg-desktop-portal-hyprland
                ];
              };
            }
          ];
        };
      };
      
      # Home Manager configurations
      homeConfigurations = {
        ${personal.user} = home-manager.lib.homeManagerConfiguration {
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
          };
          extraSpecialArgs = { 
            inherit personal; 
            inputs = self.inputs;
          };
          modules = [
            stylix.homeModules.stylix
            spicetify-nix.homeManagerModules.default
            ./home.nix
          ];
        };
      };
    };
}
