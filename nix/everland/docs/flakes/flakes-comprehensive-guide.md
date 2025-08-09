# Nix Flakes Comprehensive Guide

Based on the official NixOS Wiki (nixos.wiki/wiki/Flakes)

## What are Nix Flakes?

Nix Flakes are an **experimental feature** introduced with Nix 2.4 on November 1, 2021. They provide:
- Standard way to write Nix expressions
- Version-pinned dependencies  
- Improved reproducibility
- Better composability

## Enabling Flakes

### Temporarily
```bash
nix --experimental-features 'nix-command flakes' build
```

### Permanently on NixOS
```nix
# In configuration.nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

### For non-NixOS systems
```nix
# In ~/.config/nix/nix.conf
experimental-features = nix-command flakes
```

## Basic Flake Structure

### Core Components
Every `flake.nix` has four top-level attributes:

```nix
{
  description = "A human-readable description";
  
  inputs = {
    # Dependencies go here
  };
  
  outputs = { self, ... }: {
    # What the flake produces
  };
  
  nixConfig = {
    # Optional configuration values
  };
}
```

### Simple Example
```nix
{
  description = "My NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  
  outputs = { self, nixpkgs }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
```

## Input Types

### GitHub Repositories
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
};
```

### Git Repositories
```nix
inputs = {
  my-repo.url = "git+https://example.com/repo.git";
};
```

### Local Paths
```nix
inputs = {
  my-local-flake.url = "path:./my-flake";
};
```

### Following Other Inputs
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs
  };
};
```

## Standard Outputs

### For NixOS Systems
```nix
outputs = { self, nixpkgs }: {
  nixosConfigurations = {
    hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
};
```

### For Home Manager
```nix
outputs = { self, nixpkgs, home-manager }: {
  homeConfigurations = {
    username = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
};
```

### For Packages
```nix
outputs = { self, nixpkgs }: {
  packages.x86_64-linux = {
    my-package = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      pname = "my-package";
      version = "1.0.0";
      # ... derivation definition
    };
  };
};
```

### For Development Shells
```nix
outputs = { self, nixpkgs }: {
  devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
    buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
      nodejs
      python3
    ];
  };
};
```

## Essential Commands

### Initialize a Flake
```bash
nix flake init                    # Basic template
nix flake init -t templates#rust  # From template
```

### Update Dependencies  
```bash
nix flake update                  # Update all inputs
nix flake lock --update-input nixpkgs  # Update specific input
```

### Build and Run
```bash
nix build .#package-name          # Build package
nix run .#package-name            # Run package
nix develop                       # Enter dev shell
```

### System Management
```bash
nixos-rebuild switch --flake .#hostname
home-manager switch --flake .#username
```

## Best Practices

### 1. Pin Dependencies
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";  # Pinned version
  # NOT: nixpkgs.url = "nixpkgs";  # Unpinned
};
```

### 2. Use Follows for Consistency
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### 3. Organize with flake-utils
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  flake-utils.url = "github:numtide/flake-utils";
};

outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system: {
    # Cross-platform definitions
  });
```

### 4. Use nix-direnv
Create `.envrc`:
```bash
use flake
```

## Security Warnings

⚠️ **NEVER** include unencrypted secrets in flake files!
⚠️ Only files tracked by Git are copied to Nix store
⚠️ Flakes are experimental and may change

## Advanced Features

### Overriding Inputs
```bash
nix build --override-input nixpkgs github:NixOS/nixpkgs/master
```

### Local Development
```bash
nix develop path:./my-local-flake
```

### Template Creation
```nix
outputs = { self }: {
  templates.default = {
    path = ./template;
    description = "My project template";
  };
};
```

## Common Patterns

### Multi-system Configuration
```nix
{
  nixosConfigurations = {
    desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/desktop ];
    };
    laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      modules = [ ./hosts/laptop ];
    };
  };
}
```

### Shared Configuration
```nix
let
  commonModules = [
    ./common.nix
    home-manager.nixosModules.home-manager
  ];
in
{
  nixosConfigurations = {
    host1 = nixpkgs.lib.nixosSystem {
      modules = commonModules ++ [ ./host1.nix ];
    };
    host2 = nixpkgs.lib.nixosSystem {
      modules = commonModules ++ [ ./host2.nix ];
    };
  };
}
```