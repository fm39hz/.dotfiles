.PHONY: update clean build nixos-config

update:
	home-manager switch -b backup --flake .#fm39hz-desktop

clean:
	nix-collect-garbage -d
	home-manager switch -b backup --flake .#fm39hz

build:
	home-manager build --flake .#fm39hz

# Generate hardware configuration for NixOS installation
# Run this from NixOS installer after mounting target filesystem to /mnt
nixos-config:
	@echo "Generating hardware configuration..."
	@echo "Note: This should be run from NixOS installer with target filesystem mounted to /mnt"
	sudo nixos-generate-config --root /mnt --show-hardware-config > hardware-configuration.nix
	@echo "Hardware configuration saved to hardware-configuration.nix"
