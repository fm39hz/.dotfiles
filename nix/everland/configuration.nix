# Basic NixOS configuration for use with flakes
{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };
  
  # Enable zsh system-wide
  programs.zsh.enable = true;
  
  # Essential system packages (minimal - most apps managed via Home Manager)
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    home-manager
    greetd.tuigreet
  ];
  
  # System services
  services = {
    openssh.enable = true;
    
    # Audio system
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    
    # Docker service - handled by virtualisation.docker
    
    # Bluetooth
    blueman.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Location services can be added if needed
    # geoclue2.enable = true; # For location services
    
    # Database services (optional - enable if needed)
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    # };
    
    # Desktop portal
    dbus.enable = true;
    
    # Greetd login manager (alternative to display managers)
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    
    # Network time sync
    timesyncd.enable = true;
    
    # System monitoring
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
    
    # Gaming support - Steam configured separately
    
    # Hardware support
    fwupd.enable = true; # Firmware updates
    
    # Input method support
    xserver = {
      enable = true;
      displayManager.gdm.enable = false; # We use greetd instead
    };
  };
  
  # Hardware acceleration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };
  
  # Gaming and graphics
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  # Virtualization
  virtualisation.docker.enable = true;
  
  # Explicitly disable PulseAudio since we're using PipeWire
  services.pulseaudio.enable = false;
  
  # Security configuration
  security.rtkit.enable = true;
  
  # Filesystem configuration is now handled by hardware-configuration.nix
  # The make nixos-config command will generate the proper hardware configuration
  # including filesystems, boot settings, and hardware-specific options
}