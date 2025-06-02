# ~/.config/nixos/hosts/fm39hz-desktop/default.nix - COMPLETE module enablement
{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "fm39hz-desktop";

  # Enable all modules
  modules = {
    desktop.hyprland.enable = true;
    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;
    hardware.nvidia.enable = false; # Set to true if you have Nvidia
    programs.gaming.enable = true;
    programs.development.enable = true;
    programs.media.enable = true;
    services.docker.enable = true;
    themes.everforest.enable = true;
  };

  # User packages - ALL applications from your Arch setup
  users.users.fm39hz = {
    isNormalUser = true;
    description = "FM39hz";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Browsers (available in nixpkgs)
      brave firefox microsoft-edge
      
      # Communication (available in nixpkgs)
      telegram-desktop discord vesktop
      _64gram # 64gram-desktop equivalent
      
      # Productivity (available in nixpkgs)
      obsidian libreoffice-fresh
      
      # Development IDEs (available in nixpkgs)  
      vscode beekeeper-studio bruno postman
      
      # Terminals
      ghostty kitty
      
      # System tools
      brightnessctl networkmanagerapplet
      fastfetch lshw acpi figlet cmatrix
      
      # File management
      thunar xfce.thunar-archive-plugin
      yazi zathura zathura-pdf-mupdf
      
      # Media (available in nixpkgs)
      vlc obs-studio spotify
      
      # Gaming
      steam lutris wine
      
      # Utilities (available in nixpkgs)
      kdeconnect solaar
      
      # Development (available in nixpkgs)
      flutter
      
      # Panel - via flake input
      inputs.hyprpanel.packages.${pkgs.system}.default
    ];
  };

  # System packages that need to be at system level
  environment.systemPackages = with pkgs; [
    # Boot/system
    efibootmgr linux-firmware intel-ucode
    
    # Keyd for key remapping  
    keyd
    
    # Bluetooth
    bluez bluez-utils blueman
    
    # Audio/Video drivers
    libva-utils intel-media-driver intel-vaapi-driver
    # libva-nvidia-driver # If using Nvidia
    vulkan-tools vulkan-headers
    
    # Fonts (already in fonts.nix but ensuring completeness)
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    dejavu_fonts jetbrains-mono
    adobe-source-han-sans adobe-source-han-serif
    
    # Shell and tools
    fish nushell zellij tmux
    starship
    
    # File compression
    unzip unrar p7zip
    
    # Search/indexing
    plocate
  ];

  # Services
  services = {
    # Input method
    ibus.enable = true;
    
    # Bluetooth
    blueman.enable = true;
    
    # GPS (if needed)
    # gpsd.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Fingerprint
    fprintd.enable = true;
    
    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
