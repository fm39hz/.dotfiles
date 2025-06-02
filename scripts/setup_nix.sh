#!/usr/bin/env bash
# ~/.config/nixos/scripts/setup.sh

set -e

NIXOS_CONFIG_DIR="$HOME/.config/nixos"
SYSTEM_CONFIG_DIR="/etc/nixos"

echo "Setting up NixOS configuration..."

# Backup existing system config and symlink entire directory
if [ -d "$SYSTEM_CONFIG_DIR" ] && [ ! -L "$SYSTEM_CONFIG_DIR" ]; then
  sudo mv "$SYSTEM_CONFIG_DIR" "$SYSTEM_CONFIG_DIR.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backed up existing configuration"
fi

# Symlink entire nixos directory
sudo ln -sf "$NIXOS_CONFIG_DIR" "$SYSTEM_CONFIG_DIR"

# Generate fresh hardware configuration
echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > \
  "$NIXOS_CONFIG_DIR/hosts/fm39hz-desktop/hardware-configuration.nix"

# Set correct ownership
sudo chown -R "$(whoami):$(id -gn)" "$NIXOS_CONFIG_DIR"

# Git setup
cd "$NIXOS_CONFIG_DIR"
git add -A
echo "Added NixOS config to git"

# Rebuild system
echo "Rebuilding NixOS..."
sudo nixos-rebuild switch --flake "$SYSTEM_CONFIG_DIR#fm39hz-desktop"

# Setup user configurations
echo "Setting up user configurations..."

# Oh My Fish
curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# Cursors
mkdir -p ~/.icons/
wget -qO- https://github.com/talwat/everforest-cursors/releases/latest/download/everforest-cursors-variants.tar.bz2 |
  tar xfj - -C ~/.icons

# Git config
git config --global core.attributesfile ~/.config/git/.gitattribute

# Create directories
mkdir -p ~/Pictures/ScreenShots ~/Workspace

echo "Setup complete! Reboot recommended."
echo ""
echo "Usage:"
echo "  Update system: sudo nixos-rebuild switch --flake /etc/nixos#fm39hz-desktop"
echo "  Update flake:  nix flake update"
echo "  Home Manager:  home-manager switch --flake /etc/nixos#fm39hz"
