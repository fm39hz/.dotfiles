# Current NixOS Everland Structure Analysis

Nix Flake Configuration:

- Location: /home/fm39hz/.config/nix/everland/
- Structure: Well-organized modular approach with home-manager
- Hyprland Module: Already configured with plugins and sourcing existing config files
- Current Packages: Only basic packages (lazygit, lazydocker, ghostty, kitty)

Today's Package List (2025-08-09):

Main Repository (190 packages): Core system packages including development tools, media, productivity
apps
AUR/Local (89 packages): Specialized packages, many GUI applications and development tools

Current Hyprland Setup:

Advanced Features:

- Plugins: xtra-dispatchers, hyprsplit, hyprspace
- Complex Keybindings: Smart directional movement, workspace management, special workspaces
- Multiple Monitors: eDP-1 (1920x1080@60), DP-1 (1920x1080@170), HDMI-A-1
- Everforest Theme: Custom styling with transparency, blur effects
- App Integration: hyprpanel, app2unit for session management
- Advanced Autostart: 16+ applications with service management

Updated Migration Strategy

Based on this analysis, here's your refined migration plan:

Phase 1: Complete Package Migration (Priority)

Core Packages to Add to Nix Configuration:

## Development Environment (High Priority)

nodejs-lts-jod, python-pip, rust, go, jdk17-openjdk
dotnet-sdk, dotnet-sdk-8.0, clang, cmake, ninja, maven
docker, docker-buildx, docker-compose

## Desktop Environment (Critical)

hyprland, hyprpaper, hypridle, hyprlock, hyprshot, hyprsunset
waybar, rofi-wayland, kitty, ghostty, wlogout
hyprpolkitagent, hyprpicker

## AUR Packages Requiring Attention

app2unit-git, hyprpanel-git, everforest-theme packages
visual-studio-code-bin, brave-nightly-bin, thorium-browser-bin

Phase 2: Hyprland Configuration Integration

Critical Elements:

1. Multi-Monitor Setup: eDP-1, DP-1 (170Hz!), HDMI-A-1
2. Hyprland Plugins: Need nixpkgs or custom derivations
3. App2unit Integration: Critical for session management
4. Autostart Services: 16 applications need proper systemd integration
5. Everforest Theme: Colors, cursors, icons across system

Phase 3: Advanced Features

Special Configurations:

1. Vietnamese Input: fcitx5-bamboo (critical for your workflow)
2. Gaming Setup: Steam with MangoHUD, performance optimization
3. Development Tools: MongoDB, PostgreSQL, specialized IDEs
4. Content Creation: OBS, Blender, graphics tools

Key Migration Challenges:

1. app2unit-git: Central to your session management - needs NixOS equivalent
2. hyprpanel-git: Your status bar solution
3. 170Hz Monitor: Hardware-specific configuration
4. Vietnamese Input: fcitx5-bamboo critical for daily use
5. Custom Scripts: 16+ autostart applications need systemd services

Immediate Next Steps:

1. Expand home.nix packages with today's package list
2. Configure monitor settings in Hyprland module
3. Set up app2unit equivalent or alternative session management
4. Test Vietnamese input setup priority
5. Migrate Hyprland autostart to systemd services
