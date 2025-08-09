# Troubleshooting Guide

## Common Build Issues

### Flake Syntax Errors

#### Error: "error: syntax error, unexpected..."
```
Solution:
1. Check flake.nix syntax with: nix flake check
2. Common issues:
   - Missing commas in attribute sets
   - Incorrect string interpolation
   - Unmatched parentheses/braces
```

#### Error: "flake.lock is not locked"
```bash
# Fix by updating flake inputs
nix flake update
```

#### Error: "input 'nixpkgs' does not exist"
```nix
# Ensure inputs are properly defined
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  # NOT: nixpkgs.url = "nixpkgs";
};
```

### Package Issues

#### Error: "Package 'X' not found"
```bash
# Search for correct package name
nix search nixpkgs package-name

# Check if package exists for your system
nix eval nixpkgs#package-name.meta.platforms
```

#### Error: "Package 'X' is broken"
```bash
# Check package status
nix eval nixpkgs#package-name.meta.broken

# Use different version if available
pkgs.package-name.override { /* options */ }
```

#### Error: "Hash mismatch"
```bash
# Get correct hash
nix-prefetch-url https://example.com/file

# Or let Nix tell you the expected hash
# Set hash to empty string and run build
```

### Home Manager Issues

#### Error: "homeManagerConfiguration requires 'pkgs'"
```nix
# Correct syntax (post-22.11):
homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  modules = [ ./home.nix ];
};

# NOT the old syntax:
# homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
#   system = "x86_64-linux";
#   username = "user";
#   homeDirectory = "/home/user";
# };
```

#### Error: "Collision between 'X' and 'Y'"
```nix
# Use lib.mkForce to override
programs.bash.enable = lib.mkForce false;

# Or prioritize one option
programs.bash.enable = lib.mkDefault true;
```

#### Error: "Cannot find home-manager"
```bash
# Ensure channel is added
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Or use flakes
home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## System Configuration Issues

### Boot Problems

#### System won't boot after rebuild
```bash
# Boot from previous generation
# Select older generation in boot menu

# Or rollback
sudo nixos-rebuild switch --rollback
```

#### Error: "bootloader installation failed"
```nix
# Check boot configuration
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
};

# For BIOS systems:
boot.loader.grub = {
  enable = true;
  device = "/dev/sda";  # Adjust device
};
```

### Service Configuration Issues

#### Service fails to start
```bash
# Check service status
systemctl status service-name

# View logs
journalctl -u service-name -f

# Check configuration syntax
nixos-rebuild dry-build
```

#### Permission denied errors
```nix
# Ensure user is in required groups
users.users.username = {
  extraGroups = [ "wheel" "networkmanager" "docker" ];
};

# Or configure service properly
systemd.services.myservice = {
  serviceConfig = {
    User = "myuser";
    Group = "mygroup";
  };
};
```

## Network Issues

### DNS Resolution Problems
```nix
# Configure DNS
networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

# Or use systemd-resolved
services.resolved.enable = true;
```

### WiFi Connection Issues
```nix
# Enable NetworkManager
networking.networkmanager.enable = true;

# Add user to networkmanager group
users.users.username.extraGroups = [ "networkmanager" ];
```

### Firewall Blocking Connections
```nix
# Open specific ports
networking.firewall = {
  allowedTCPPorts = [ 80 443 22 ];
  allowedUDPPorts = [ 53 ];
};

# Or disable firewall (not recommended)
networking.firewall.enable = false;
```

## Hardware Issues

### Graphics Driver Problems

#### NVIDIA Driver Issues
```nix
# Enable NVIDIA drivers
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  open = false;  # Use proprietary driver
  nvidiaSettings = true;
};

# Enable OpenGL
hardware.opengl = {
  enable = true;
  driSupport = true;
  driSupport32Bit = true;
};
```

#### Intel Graphics Issues
```nix
# Enable Intel graphics
services.xserver.videoDrivers = [ "modesetting" ];
hardware.opengl = {
  enable = true;
  extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
};
```

### Audio Problems

#### No Sound Output
```nix
# Enable PipeWire
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

# Disable PulseAudio
hardware.pulseaudio.enable = false;
```

#### Wrong Audio Device
```bash
# List available devices
pactl list sinks

# Set default sink
pactl set-default-sink sink-name
```

## Development Environment Issues

### Python Environment Problems
```nix
# Use python-with-packages
environment.systemPackages = [
  (pkgs.python3.withPackages (ps: with ps; [
    requests
    numpy
    flask
  ]))
];

# Or use shell environments
shell.nix:
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [
      requests
      numpy
    ]))
  ];
}
```

### Node.js Version Issues
```nix
# Use specific Node.js version
environment.systemPackages = [ pkgs.nodejs_18 ];

# Or use node2nix for projects
# Generate with: node2nix -l package-lock.json
```

### Library Not Found Errors
```nix
# Use buildFHSUserEnv for complex dependencies
environment.systemPackages = [
  (pkgs.buildFHSUserEnv {
    name = "myapp-env";
    targetPkgs = pkgs: with pkgs; [
      # Required libraries
      libGL
      libGLU
      openssl
    ];
    runScript = "bash";
  })
];
```

## Storage and Performance Issues

### Disk Space Problems
```bash
# Clean up old generations
nix-collect-garbage -d

# Optimize store
nix-store --optimize

# Check store usage
du -sh /nix/store
```

### Slow Builds
```bash
# Use binary cache
nix.settings = {
  substituters = [
    "https://cache.nixos.org/"
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};

# Increase build jobs
nix.settings.max-jobs = 8;
```

### Build Cache Issues
```bash
# Clear bad cache
nix-store --delete /nix/store/bad-path

# Repair store
nix-store --repair-path /nix/store/path

# Verify integrity
nix-store --verify --check-contents
```

## Community Flakes Issues

### Flake Input Errors
```nix
# Ensure inputs follow nixpkgs
zen-browser = {
  url = "github:youwen5/zen-browser-flake";
  inputs.nixpkgs.follows = "nixpkgs";  # Important!
};
```

### Package Not Available for System
```bash
# Check supported systems
nix flake show github:author/repo

# Look for system-specific outputs
nix eval github:author/repo#packages.x86_64-linux
```

### Upstream Changes Breaking Build
```bash
# Pin to working commit
zen-browser.url = "github:youwen5/zen-browser-flake/commit-hash";

# Or update lock file
nix flake lock --update-input zen-browser
```

## Debugging Techniques

### Trace Evaluation
```nix
# Add debug output
let
  myValue = builtins.trace "Debug: myValue is ${toString myValue}" myValue;
in
{
  # Configuration using myValue
}
```

### Show Evaluation
```bash
# Show what would be built
nixos-rebuild dry-build

# Show all options
nixos-option services.nginx

# Evaluate expressions
nix eval .#nixosConfigurations.hostname.config.environment.systemPackages
```

### Build Debugging
```bash
# Keep failed builds
nix build --keep-failed

# Show detailed trace
nix build --show-trace

# Enter build environment
nix develop .#package-name
```

### System State Debugging
```bash
# Show system closure
nix-store -q --tree /run/current-system

# Show package dependencies
nix-store -q --references /nix/store/package-hash

# Find which package provides file
nix-locate bin/command
```

## Recovery Procedures

### System Recovery
```bash
# Boot from NixOS installer
# Mount existing system
sudo mount /dev/sda1 /mnt
sudo nixos-enter

# Rollback to working generation
sudo nix-env --rollback --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

### Home Manager Recovery
```bash
# Rollback home manager
home-manager generations
/nix/store/generation-hash-home-manager-generation/activate
```

### Configuration Backup
```bash
# Backup working configuration
cp -r ~/.config/nixos ~/nixos-backup-$(date +%Y%m%d)

# Version control your configs (recommended)
git init
git add .
git commit -m "Working configuration"
```

This troubleshooting guide covers the most common issues encountered when using NixOS, Home Manager, and Flakes.