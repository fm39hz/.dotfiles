# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fm39hz-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      bamboo
    ];
  };

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

  # Enable Hyprland (Wayland compositor)
  programs.hyprland.enable = true;
  
  # Enable the X11 windowing system (for compatibility)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            esc = "capslock";
          };
        };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable Docker
  virtualisation.docker.enable = true;
  
  # Enable Steam
  programs.steam.enable = true;
  
  # Enable Fish shell
  programs.fish.enable = true;
  
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
        serif = [ "Jetbrains Mono Bold" ];
        sansSerif = [ "Jetbrains Mono ExtraBold" ];
        monospace = [ "Jetbrains Mono Bold" ];
      };
    };
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  
  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    setOptions = [
      "AUTO_CD"
    ];
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "juanghurtado";
      };
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.fm39hz = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "fm39hz-desktop";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # Development Tools
      git
      git-lfs
      lazygit
      github-cli
      neovim
      neovide
      zed-editor
      vscode
      jetbrains.rider
      
      # Terminal & Shell
      ghostty
      kitty
      tmux
      zellij
      btop
      fish
      nushell
      starship
      
      # System utilities
      brightnessctl
      chafa
      fd
      fzf
      ripgrep
      tree
      rsync
      wget
      curl
      unzip
      unrar
      _7zz
      keyd
      yazi
      zoxide
      gum
      
      # Programming Languages & Runtimes
      clang
      cmake
      ninja
      rust
      nodejs
      npm
      bun
      dotnet-sdk
      aspnetcore-runtime
      jdk17
      maven
      php
      composer
      python3
      python3Packages.pip
      lua51
      luarocks
      mono
      nasm
      
      # Media & Graphics
      blender
      gimp
      vlc
      obs-studio
      imagemagick
      ffmpeg
      sox
      mpd
      
      # Browsers
      brave
      microsoft-edge
      
      # Communication
      _64gram
      discord
      
      # Office & Productivity
      obsidian
      libreoffice
      
      # Hyprland ecosystem
      hyprland
      hyprpaper
      hyprlock
      hypridle
      hyprpicker
      waybar
      rofi-wayland
      wlogout
      swww
      
      # Audio/Video utilities
      pipewire
      wireplumber
      libnotify
      
      # File managers
      thunar
      xfce.thunar-archive-plugin
      
      # Archive managers
      xarchiver
      
      # PDF viewer
      zathura
      mupdf
      
      # Network tools
      networkmanager
      networkmanagerapplet
      nmap
      iw
      
      # Gaming
      steam
      wine
      
      # Databases
      mariadb
      
      # Cloud tools
      cloudflared
      
      # System info
      fastfetch
      lshw
      plocate
      
      # Text processing
      figlet
      cmatrix
      lynx
      
      # Wayland/X11 utilities
      wl-clipboard
      xclip
      wmctrl
      
      # Development databases
      # Note: Add other specific packages as needed
      
      # Fonts (additional)
      # Already configured in fonts section above
    ];
  };

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    wget
    gnomeExtensions.blur-my-shell
    gnomeExtensions.focus-changer
    gnomeExtensions.tiling-shell
    gnomeExtensions.user-themes
    gnomeExtensions.unite
    gnomeExtensions.rounded-corners
    
    # Additional system-wide packages
    acpi
    efibootmgr
    intel-media-driver
    intel-vaapi-driver
    libva-utils
    linux-firmware
    powertop
    vulkan-tools
    mesa
    
    # Wayland/Desktop portal
    xdg-desktop-portal-gtk
    
    # Input method
    fcitx5
    fcitx5-configtool
    
    # Notification daemon
    libnotify
    
    # Power management
    power-profiles-daemon
  ];

  nix.gc = { 
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet/";
    # Add Wayland support
    NIXOS_OZONE_WL = "1";
  };

  # Hardware support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable hardware video acceleration
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    libva
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
