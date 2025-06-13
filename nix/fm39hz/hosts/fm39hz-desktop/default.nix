# ~/.config/nixos/hosts/fm39hz-desktop/default.nix
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
    services.greetd.enable = true;
    services.keyd.enable = true;
    themes.everforest.enable = true;
  };

  # User configuration
  users.users.fm39hz = {
    isNormalUser = true;
    description = "FM39hz";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Browsers
      brave firefox
      
      # Communication
      _64Gram vesktop
      
      # Productivity
      obsidian libreoffice-fresh
      
      # Development IDEs  
      vscode jetbrains.idea-community
      beekeeper-studio bruno postman
      
      # Terminals
      ghostty kitty
      
      # System tools
      brightnessctl
      lshw acpi figlet cmatrix
      
      # File management
      thunar xfce.thunar-archive-plugin
      yazi zathura zathura-pdf-mupdf
      
      # Media
      vlc obs-studio spotify
      
      # Gaming
      steam lutris wine
      
      # Utilities
      kdeconnect solaar
      
      # Development
      flutter
      
      # HyprPanel (if available)
      (inputs.hyprpanel.packages.${pkgs.system}.default or null)
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Boot/system
    efibootmgr linux-firmware
    
    # Bluetooth
    bluez bluez-utils blueman
    
    # Fonts
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    dejavu_fonts jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    adobe-source-han-sans adobe-source-han-serif
    
    # Shell and tools
    fish nushell zellij tmux starship
    
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
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Fingerprint
    fprintd.enable = true;
    
    # Location service
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      adobe-source-han-sans
      adobe-source-han-serif
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrains Mono Bold" ];
        sansSerif = [ "JetBrains Mono ExtraBold" ];
        monospace = [ "JetBrains Mono Bold" ];
      };
    };
  };

  system.stateVersion = "25.05";
}
