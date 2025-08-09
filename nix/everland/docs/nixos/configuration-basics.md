# NixOS Configuration Basics

Based on the official NixOS manual (nixos.org/manual/nixos/stable/)

## Configuration Syntax and Structure

The NixOS configuration file is a Nix expression, typically located at `/etc/nixos/configuration.nix` or in flakes.

### Basic Structure
```nix
{ config, pkgs, ... }:

{
  # option definitions go here
}
```

## Key Configuration Features

### 1. Nested Configuration
Configuration uses dot notation for hierarchical settings:
```nix
{
  networking.hostName = "myhost";
  services.sshd.enable = true;
  boot.loader.systemd-boot.enable = true;
}
```

### 2. Modular Configuration
Split configuration across multiple files:
```nix
{
  imports = [ 
    ./hardware-configuration.nix
    ./users.nix
    ./services.nix
  ];
}
```

### 3. Abstractions with `let` bindings
```nix
{ config, pkgs, ... }:

let
  myPackages = with pkgs; [ firefox thunderbird ];
in
{
  environment.systemPackages = myPackages;
}
```

## Package Management

### Declarative Package Installation
```nix
{
  environment.systemPackages = with pkgs; [ 
    thunderbird 
    firefox 
    git
    vim
  ];
}
```

### Package Customization
```nix
{
  environment.systemPackages = with pkgs; [
    (firefox.override { 
      enableGoogleTalkPlugin = true; 
    })
  ];
}
```

### Global nixpkgs Configuration
```nix
{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      # custom package definitions
    };
  };
}
```

## System Rebuilding

### Commands
- `nixos-rebuild switch` - Apply configuration and switch to it
- `nixos-rebuild test` - Apply configuration temporarily
- `nixos-rebuild boot` - Apply configuration for next boot
- `nixos-rebuild build` - Build configuration without applying

### With Flakes
- `nixos-rebuild switch --flake .#hostname`
- `nixos-rebuild test --flake .#hostname`

## Key Principles

1. **Declarative**: Describe what the system should look like
2. **Functional**: Configuration is a pure function
3. **Reproducible**: Same configuration = same system
4. **Modular**: Compose configuration from reusable parts
5. **Type-safe**: Configuration options are validated

## Common Patterns

### User Management
```nix
{
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ firefox tree ];
  };
}
```

### Service Configuration
```nix
{
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    nginx.enable = true;
  };
}
```

### Hardware Configuration
```nix
{
  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
  };
}
```