# Basic NixOS configuration for use with flakes
{ config, pkgs, lib, ... }:

{
  # Basic system configuration
  system.stateVersion = "25.05"; # Did you read the comment?
  
  # Bootloader configuration (adjust for your system)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking configuration
  networking = {
    hostName = "fm39hz-desktop";
    networkmanager.enable = true;
  };
  
  # Time and locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # User configuration
  users.users.fm39hz = {
    isNormalUser = true;
    description = "FM39HZ";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  
  # Essential system packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    home-manager
  ];
  
  # Essential services
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  
  # Explicitly disable PulseAudio since we're using PipeWire
  services.pulseaudio.enable = false;
  
  # Security configuration
  security.rtkit.enable = true;
  
  # Basic filesystem configuration (adjust during actual installation)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";  # Adjust to your actual root device
    fsType = "ext4";
  };
  
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";   # Adjust to your actual boot device
    fsType = "vfat";
  };
  
  # Note: During actual NixOS installation, hardware-configuration.nix
  # will be auto-generated with your specific hardware details
}