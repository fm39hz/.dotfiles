# PLACEHOLDER: This file will be overwritten by 'make nixos-config'
# Run 'make nixos-config' from NixOS installer to generate actual hardware configuration
# This is modeled after real nixos-generate-config output
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # PLACEHOLDER: These will be detected by nixos-generate-config
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"]; # or kvm-amd
  boot.extraModulePackages = [];

  # PLACEHOLDER: Real UUIDs will be generated
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # PLACEHOLDER: Swap configuration will be detected
  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface
  networking.useDHCP = lib.mkDefault true;
  # Network interfaces will be detected and configured

  # System architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  # CPU microcode will be detected (Intel or AMD)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}