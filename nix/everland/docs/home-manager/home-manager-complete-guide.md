# Home Manager Complete Guide

Based on the official Home Manager manual (nix-community.github.io/home-manager/)

## What is Home Manager?

Home Manager is a system for managing user environments using the Nix package manager. It provides:
- Declarative configuration of user-specific packages and dotfiles
- Reproducible user environments
- Integration with NixOS systems
- Support for Nix Flakes

## Installation Methods

### 1. Standalone Installation

#### Step 1: Add Home Manager Channel
```bash
# For stable release
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update

# For unstable (latest)  
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

#### Step 2: Install Home Manager
```bash
nix-shell '<home-manager>' -A install
```

#### Step 3: Source Environment Variables
Add to your shell configuration:
```bash
# For bash/zsh
source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

# Or if using fish
fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
```

### 2. NixOS Module Installation

Add to `configuration.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.alice = {
    isNormalUser = true;
    # ... other user options
  };

  home-manager.users.alice = { pkgs, ... }: {
    home.stateVersion = "25.05";
    
    # Home Manager configuration goes here
    programs.bash.enable = true;
  };
}
```

### 3. Flakes Installation

#### Initialize Home Manager with Flakes
```bash
# For unstable version
nix run home-manager/master -- init --switch

# For stable 25.05 version  
nix run home-manager/release-25.05 -- init --switch
```

#### Basic Flake Structure
```nix
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."username" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
}
```

## Basic Configuration

### Minimal home.nix
```nix
{ config, pkgs, ... }:

{
  home.username = "jdoe";
  home.homeDirectory = "/home/jdoe";
  home.stateVersion = "25.05"; # Never change this after initial setup!

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
```

### With Package Installation
```nix
{ config, pkgs, ... }:

{
  home.username = "alice";
  home.homeDirectory = "/home/alice";
  home.stateVersion = "25.05";

  # Install packages
  home.packages = with pkgs; [
    firefox
    git
    vim
    tree
  ];

  # Enable programs with configuration
  programs = {
    home-manager.enable = true;
    
    bash = {
      enable = true;
      bashrcExtra = ''
        export EDITOR=vim
      '';
    };
    
    git = {
      enable = true;
      userName = "Alice";
      userEmail = "alice@example.com";
    };
  };
}
```

## Flakes Integration

### Complete Flake with NixOS
```nix
{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alice = import ./home.nix;
        }
      ];
    };

    # Standalone Home Manager configuration
    homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
}
```

### homeManagerConfiguration Parameters

#### Required Parameters
```nix
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;  # Package set
  modules = [ ./home.nix ];                    # Configuration modules
}
```

#### Optional Parameters
```nix
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  modules = [ ./home.nix ];
  
  # Pass extra arguments to modules
  extraSpecialArgs = {
    inherit inputs;
    myVariable = "value";
  };
}
```

## Essential Commands

### Standalone Home Manager
```bash
home-manager switch           # Apply configuration
home-manager build            # Build without switching
home-manager generations      # List generations
home-manager remove-generations 5d  # Remove old generations
```

### With Flakes
```bash
home-manager switch --flake .#username
home-manager build --flake .#username
nix build .#homeConfigurations.username.activationPackage
```

### NixOS Module
```bash
sudo nixos-rebuild switch    # Also rebuilds Home Manager
```

## Configuration Structure

### Modular Configuration
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/vim.nix
    ./services/gpg.nix
  ];

  home.username = "alice";
  home.homeDirectory = "/home/alice";
  home.stateVersion = "25.05";
}
```

### Example Module (programs/git.nix)
```nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Alice";
    userEmail = "alice@example.com";
    
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
    };
    
    extraConfig = {
      core.editor = "vim";
      pull.rebase = true;
    };
  };
}
```

## Common Program Configurations

### Shell Configuration
```nix
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "kubectl" ];
    };
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
    };
  };
}
```

### Dotfile Management
```nix
{
  home.file = {
    ".vimrc".source = ./dotfiles/vimrc;
    ".gitignore".text = ''
      *.swp
      *.tmp
      .DS_Store
    '';
    
    ".config/alacritty/alacritty.yml".source = 
      ./config/alacritty.yml;
  };
}
```

### Service Configuration
```nix
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSshSupport = true;
  };
  
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x5-30+20";
        transparency = 10;
        frame_color = "#eceff1";
        font = "Droid Sans 9";
      };
    };
  };
}
```

## Best Practices

### 1. Never Change stateVersion
```nix
{
  # Set this once during initial setup and NEVER change it
  home.stateVersion = "25.05";
}
```

### 2. Use Version Pinning
```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";  # Pinned
  home-manager.url = "github:nix-community/home-manager/release-25.05";
};
```

### 3. Organize Configuration
```
home-manager/
├── flake.nix
├── home.nix
├── programs/
│   ├── git.nix
│   ├── vim.nix
│   └── zsh.nix
├── services/
│   └── gpg.nix
└── dotfiles/
    ├── vimrc
    └── gitconfig
```

### 4. Use extraSpecialArgs for Sharing
```nix
extraSpecialArgs = { 
  inherit inputs;
  myTheme = import ./theme.nix;
};
```

## Troubleshooting

### Common Issues
1. **Permission errors**: Ensure proper file ownership
2. **Activation failures**: Check configuration syntax
3. **Channel mismatches**: Use consistent versions

### Debugging Commands
```bash
home-manager build --show-trace   # Detailed error output
nix-store --verify --check-contents  # Check store integrity
```

### Rollback
```bash
home-manager generations
/nix/store/xxx-home-manager-generation/activate
```

## Advanced Features

### Custom Modules
```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.myprogram;
in
{
  options.programs.myprogram = {
    enable = lib.mkEnableOption "My Program";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.myprogram;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
```

### Conditional Configuration
```nix
{ config, lib, pkgs, ... }:

{
  programs.git.enable = true;
  
  # Linux-specific configuration
  programs.git.extraConfig = lib.mkIf pkgs.stdenv.isLinux {
    credential.helper = "store";
  };
  
  # macOS-specific configuration  
  programs.git.extraConfig = lib.mkIf pkgs.stdenv.isDarwin {
    credential.helper = "osxkeychain";
  };
}
```