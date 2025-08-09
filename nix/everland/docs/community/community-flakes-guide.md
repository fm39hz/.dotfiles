# Community Flakes Guide

## Overview

Community flakes provide packages not available in the official nixpkgs repository. This guide covers the flakes used in your configuration.

## Zen Browser Flake

**Repository**: https://github.com/youwen5/zen-browser-flake  
**Maintainer**: youwen5  
**Auto-updates**: Daily via GitHub Actions

### Available Packages
- `zen-browser`: Default package (recommended)
- `zen-browser-unwrapped`: Base browser without wrapper

### Installation in Flakes
```nix
# In flake.nix inputs:
zen-browser = {
  url = "github:youwen5/zen-browser-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In configuration:
environment.systemPackages = [
  inputs.zen-browser.packages.${pkgs.system}.default
];
```

### Home Manager Usage
```nix
home.packages = [
  inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

### Features
- Automatic daily updates from upstream Zen releases
- Disabled browser update checks (managed by Nix)
- Custom Firefox policies support via `override`
- GPU acceleration support with proper configuration

### Known Issues
- GPU acceleration may require additional system configuration
- 1Password integration needs manual setup

## Thorium Browser Flake

**Repository**: https://github.com/siryoussef/thorium-browser-nix  
**Maintainer**: siryoussef

### Description
Chromium fork with performance optimizations including:
- SSE4.2, AVX, AES compiler optimizations
- Various CFLAGS, LDFLAGS, thinLTO flags modifications
- Claims 8-38% performance improvement over vanilla Chromium

### Installation in Flakes
```nix
# In flake.nix inputs:
thorium-browser = {
  url = "github:siryoussef/thorium-browser-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In configuration:
home.packages = [
  inputs.thorium-browser.packages.${pkgs.stdenv.hostPlatform.system}.thorium-browser
];
```

## Spicetify-nix Flake

**Repository**: https://github.com/Gerg-L/spicetify-nix  
**Documentation**: https://gerg-l.github.io/spicetify-nix/  
**Maintainer**: Gerg-L

### Description
Nix library for modifying Spotify using spicetify-cli. Provides themes, extensions, and customizations.

### Installation in Flakes
```nix
# In flake.nix inputs:
spicetify-nix = {
  url = "github:Gerg-L/spicetify-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In flake.nix outputs modules:
modules = [
  spicetify-nix.homeManagerModules.default
  # ... other modules
];
```

### Home Manager Configuration
```nix
programs.spicetify = {
  enable = true;
  enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}; [
    adblock
    hidePodcasts
    shuffle
    keyboardShortcut
    fullAppDisplay
  ];
  theme = inputs.spicetify-nix.legacyPackages.${pkgs.system}.catppuccin;
  colorScheme = "mocha";
};
```

### Available Themes
Common themes include:
- `catppuccin`
- `dribbblish`
- `sleek`
- `text`
- `turntable`

### Available Extensions
Popular extensions:
- `adblock` - Block advertisements
- `hidePodcasts` - Hide podcast elements
- `shuffle` - Enhanced shuffle functionality
- `keyboardShortcut` - Custom keyboard shortcuts
- `fullAppDisplay` - Full application display

### Quick Test
```bash
nix run github:Gerg-L/spicetify-nix#test
```

## Ghostty Flake

**Repository**: https://github.com/ghostty-org/ghostty  
**Maintainer**: Official Ghostty organization

### Description
Fast, feature-rich terminal emulator written in Zig. Official repository maintains a Nix flake.

### Installation in Flakes
```nix
# In flake.nix inputs:
ghostty = {
  url = "github:ghostty-org/ghostty";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In configuration:
home.packages = [
  inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

### Features
- High performance terminal emulator
- GPU acceleration
- Rich configuration options
- Cross-platform support

## General Community Flakes Best Practices

### 1. Input Follows
Always use `inputs.nixpkgs.follows = "nixpkgs"` to ensure consistency:
```nix
community-flake = {
  url = "github:author/repo";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

### 2. Package References
Use full system path for package references:
```nix
inputs.flake-name.packages.${pkgs.stdenv.hostPlatform.system}.package-name
```

### 3. Regular Updates
Update community flakes regularly:
```bash
nix flake update
nix flake lock --update-input flake-name
```

### 4. Pinning for Stability
For production systems, consider pinning to specific commits:
```nix
zen-browser.url = "github:youwen5/zen-browser-flake/commit-hash";
```

### 5. Fallback Options
Always have fallback packages available:
```nix
home.packages = [
  # Community flake package
  inputs.zen-browser.packages.${pkgs.system}.default
  
  # Fallback to nixpkgs if available
  # pkgs.firefox
];
```

## Security Considerations

### Trust Verification
- Review flake source code before using
- Check maintainer reputation and activity
- Monitor for suspicious changes

### Update Safety
- Test updates in non-critical environments first
- Keep working configurations backed up
- Use `nix flake lock` to pin working versions

### Source Authentication
- Prefer well-maintained repositories
- Look for official or community-endorsed flakes
- Avoid flakes with suspicious or unclear origins

## Troubleshooting Community Flakes

### Build Failures
1. Check flake lock file for version conflicts
2. Update inputs: `nix flake update`
3. Clear build cache: `nix-collect-garbage`

### Package Not Found
1. Verify package name in flake repository
2. Check supported systems (x86_64-linux, aarch64-linux)
3. Ensure flake exposes the package correctly

### Version Conflicts
1. Use `inputs.nixpkgs.follows` consistently
2. Check for conflicting package versions
3. Consider using overlays for compatibility

## Contributing to Community Flakes

### Reporting Issues
- Use GitHub issues in respective repositories
- Provide system information and error logs
- Include minimal reproduction examples

### Contributing Improvements
- Fork repositories and submit pull requests
- Follow project coding standards
- Test changes across supported systems

### Creating New Flakes
- Follow official flake structure guidelines
- Provide comprehensive documentation
- Set up automated testing and updates