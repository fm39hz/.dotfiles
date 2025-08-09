# Quick Reference Guide

## Essential Commands

### Flake Management
```bash
# Initialize new flake
nix flake init

# Check flake syntax
nix flake check

# Show flake outputs
nix flake show

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake metadata
nix flake metadata
```

### Home Manager
```bash
# Switch configuration (flakes)
home-manager switch --flake .#username

# Build without switching
home-manager build --flake .#username

# List generations
home-manager generations

# Remove old generations
home-manager expire-generations -3d

# Rollback to previous generation
home-manager switch --flake .#username --switch-generation 123
```

### NixOS System
```bash
# Rebuild system (flakes)
sudo nixos-rebuild switch --flake .#hostname

# Test configuration temporarily
sudo nixos-rebuild test --flake .#hostname

# Build for next boot
sudo nixos-rebuild boot --flake .#hostname

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback system
sudo nixos-rebuild switch --rollback
```

### Package Management
```bash
# Search packages
nix search nixpkgs firefox

# Run package temporarily
nix run nixpkgs#firefox

# Install to profile
nix profile install nixpkgs#firefox

# List profile packages
nix profile list

# Remove from profile
nix profile remove firefox

# Show package information
nix show-config nixpkgs#firefox
```

### Debugging
```bash
# Detailed error output
nix build --show-trace

# Keep build directory on failure
nix build --keep-failed

# Verbose logging
nix build --verbose

# Show build logs
nix log /nix/store/hash-package

# Eval expression
nix eval .#packages.x86_64-linux.package-name
```

### System Maintenance
```bash
# Garbage collection
nix-collect-garbage

# Deep clean (remove old generations)
nix-collect-garbage -d

# Optimize store
nix-store --optimize

# Verify store integrity
nix-store --verify --check-contents

# Show store paths
nix-store --query --references /nix/store/hash

# Show reverse dependencies
nix-store --query --referrers /nix/store/hash
```

## Configuration Syntax

### Basic Flake Structure
```nix
{
  description = "My configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    # Configuration outputs
  };
}
```

### Package Installation
```nix
{
  environment.systemPackages = with pkgs; [
    firefox
    git
    vim
  ];
  
  # Or for Home Manager
  home.packages = with pkgs; [
    firefox
    git
    vim
  ];
}
```

### Service Configuration
```nix
{
  # Enable service
  services.openssh.enable = true;
  
  # Configure service
  services.nginx = {
    enable = true;
    virtualHosts."example.com" = {
      root = "/var/www/example.com";
    };
  };
}
```

### Conditionals
```nix
{
  # Simple conditional
  programs.steam.enable = lib.mkIf (system == "x86_64-linux") true;
  
  # Conditional packages
  environment.systemPackages = with pkgs; [
    firefox
  ] ++ lib.optionals stdenv.isLinux [
    # Linux-only packages
  ];
}
```

### Overlays
```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      mypackage = prev.mypackage.override {
        enableFeature = true;
      };
    })
  ];
}
```

## File Locations

### System Files
```
/etc/nixos/configuration.nix     # Legacy system config
/etc/nixos/hardware-configuration.nix  # Hardware detection
/nix/var/nix/profiles/system     # System generations
/run/current-system              # Current system
```

### User Files
```
~/.config/home-manager/          # Home Manager config dir
~/.local/state/nix/profiles/     # User profiles
~/.local/state/home-manager/     # HM generations
```

### Flake Files
```
flake.nix                        # Main flake file
flake.lock                       # Lock file (pinned inputs)
.envrc                          # direnv configuration
```

## Environment Variables

### Nix Configuration
```bash
# Enable flakes temporarily
export NIX_CONFIG="experimental-features = nix-command flakes"

# Custom config file
export NIX_CONFIG_DIR="/path/to/config"

# Build directory
export TMPDIR="/path/to/build"
```

### Home Manager
```bash
# Configuration directory
export HOME_MANAGER_CONFIG="$HOME/.config/home-manager"

# Backup extension
export HOME_MANAGER_BACKUP_EXT="backup"
```

## Common Patterns

### Let Expressions
```nix
let
  myPackages = with pkgs; [ firefox git vim ];
  myVariable = "value";
in
{
  environment.systemPackages = myPackages;
}
```

### Imports
```nix
{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./users.nix
  ];
}
```

### Functions
```nix
{ config, lib, pkgs, ... }:

let
  mkUser = name: {
    ${name} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
in
{
  users.users = mkUser "alice" // mkUser "bob";
}
```

## Package Override Examples

### Simple Override
```nix
{
  environment.systemPackages = [
    (pkgs.firefox.override {
      enableGoogleTalkPlugin = true;
    })
  ];
}
```

### Override with Overrides
```nix
{
  environment.systemPackages = [
    (pkgs.firefox.overrideAttrs (oldAttrs: {
      postInstall = oldAttrs.postInstall + ''
        # Additional install commands
      '';
    }))
  ];
}
```

### Custom Derivation
```nix
{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "mypackage";
      version = "1.0.0";
      
      src = pkgs.fetchurl {
        url = "https://example.com/mypackage-1.0.0.tar.gz";
        sha256 = "sha256-HASH";
      };
      
      buildPhase = ''
        make
      '';
      
      installPhase = ''
        make install PREFIX=$out
      '';
    })
  ];
}
```

## Error Messages & Solutions

### "flake.lock is not locked"
```bash
nix flake update
```

### "experimental feature not enabled"
```bash
# Add to ~/.config/nix/nix.conf
experimental-features = nix-command flakes
```

### "hash mismatch"
```bash
# Update hash in configuration
nix-prefetch-url https://example.com/file
```

### "derivation does not exist"
```bash
# Check package name
nix search nixpkgs package-name
```

### "infinite recursion"
- Check for circular imports
- Verify attribute names don't conflict
- Use `builtins.trace` for debugging

## Useful Libraries

### lib Functions
```nix
lib.mkIf condition value           # Conditional value
lib.mkDefault value               # Default value
lib.mkForce value                 # Force value
lib.mkOverride priority value     # Override with priority
lib.optionals condition list      # Conditional list
lib.optional condition value      # Conditional single item
lib.concatStrings list           # Concatenate strings
lib.concatStringsSep sep list     # Join with separator
```

### builtins Functions
```nix
builtins.readFile ./file         # Read file contents
builtins.fromJSON string         # Parse JSON
builtins.toJSON value            # Convert to JSON
builtins.length list             # List length
builtins.head list               # First element
builtins.tail list               # All but first
builtins.map function list       # Apply function to list
builtins.filter predicate list   # Filter list
```

This quick reference provides the most commonly used commands and patterns for NixOS and Home Manager configuration.