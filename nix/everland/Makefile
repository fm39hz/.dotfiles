.PHONY: update
update:
	home-manager switch -b backup --flake .#fm39hz-desktop

.PHONE: clean
clean:
	nix-collect-garbage -d
	home-manager switch -b backup --flake .#fm39hz

.PHONE: build
build:
	home-manager build --flake .#fm39hz
