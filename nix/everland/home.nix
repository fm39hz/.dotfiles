{ personal, pkgs, inputs, ...}:
{
  programs.home-manager.enable = true;
  imports = [
    ./modules/desktop
    # ./programs
  ];

  home = {
    packages = with pkgs; [
      # Development Tools
      lazygit
      lazydocker
      git
      git-lfs
      github-cli
      
      # Programming Languages & Runtimes
      nodejs # alias to latest LTS
      python3
      python3Packages.pip
      rustc
      cargo
      go
      openjdk17 # or temurin-bin-17
      dotnetCorePackages.sdk_8_0
      
      # Build Tools
      cmake
      ninja
      maven
      clang
      
      # Containerization
      docker
      docker-buildx
      docker-compose
      
      # Text Editors & IDEs
      neovim
      neovide
      
      # Terminal Tools
      btop
      fastfetch
      tree
      fd
      ripgrep
      fzf
      zoxide
      tmux
      zsh
      starship
      thefuck
      
      # File Management
      xfce.thunar
      xfce.thunar-archive-plugin
      yazi
      superfile
      unrar
      unzip
      
      # Media & Graphics
      vlc
      gimp
      blender
      obs-studio
      
      # Productivity
      obsidian
      libreoffice-fresh
      bitwarden
      
      # Browsers (Standard + Community Flakes)
      firefox
      chromium  
      brave
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      # inputs.thorium-browser.packages.${pkgs.stdenv.hostPlatform.system}.thorium-browser
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
      
      # Communication (Available in nixpkgs)
      _64gram # 64gram-desktop-bin equivalent
      vesktop # Discord alternative with Vencord  
      # telegram-desktop # standard Telegram client
      
      # Development Tools from nixpkgs
      vscode # visual-studio-code-bin equivalent
      mongodb-compass # Already available
      
      # Media Tools available in nixpkgs
      spotify # Available in nixpkgs now
      # Note: spicetify configured separately via module
      
      # System Utilities
      brightnessctl
      ddcutil
      plocate
      rsync
      wget
      acpi
      lshw
      
      # Audio
      pipewire
      # pipewire-alsa
      # pipewire-jack
      # pipewire-pulse
      wireplumber
      
      # Network
      networkmanager
      iw
      nmap
      cloudflared
      
      # Gaming
      steam
      
      # Fonts
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      
      # Vietnamese Input Support
      # fcitx5-bamboo # This might need to be configured separately
      
      # Archive Tools
      p7zip
      
      # Power Management
      powertop
      
      # Hardware Support
      intel-media-driver
      # libva-intel-driver
      libva-utils
      # vulkan-intel
      
      # Graphics Tools
      imagemagick
      chafa
      
      # Documentation
      man-db
      tldr
      
      # Version Control
      diff-so-fancy
      
      # Monitoring
      htop
      speedtest-cli
      
      # Terminal Multiplexer
      zellij
      
      # Shell Tools
      fish
      nushell
      vivid
      gum
      figlet
      cmatrix
      
      # Development Databases
      mariadb
      
      # Web Development
      dart-sass
      
      # Game Development
      tiled
      
      # Scientific Computing
      plantuml
      graphviz
      
      # Assembly
      nasm
      
      # System Info
      neofetch
      
      # Document Viewers
      zathura
      # zathura-pdf-mupdf
      
      # Code Formatters
      tree-sitter
      
      # Package Management
      # Note: yay and AUR packages will need alternatives
      
      # System Services
      greetd
      
      # Text Processing
      yq
      html-xml-utils
      
      # Lua
      lua5_1
      luarocks
      
      # Bluetooth
      bluez
      # bluez-utils
      blueman
      
      # Archive Management
      xarchiver
      
      # Clipboard
      xclip
      
      # Notifications
      libnotify
      # notification-daemon
      
      # Desktop Integration
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      
      # Qt/GTK
      # qt5-wayland
      libsForQt5.qt5ct
      gtk-engine-murrine
      nwg-look
      # kvantum
      
      # Power Profiles
      power-profiles-daemon
      
      # Security
      gnome-keyring
      # secrets
      
      # Video Codecs
      # gst-plugins-good
      # gst-plugin-pipewire
      
      # X11 Tools (for compatibility)
      # xorg-xev
      
      # GNOME Tools
      gnome-calculator
      gnome-disk-utility
      gnome-bluetooth
      
      # Audio Tools
      sox
      
      # Network Tools
      lynx
      
      # Compression
      zram-generator
      
      # Development Tools
      entr
      libfaketime
      
      # Session Management
      uwsm # Universal Wayland Session Manager (replaces app2unit)
      
      # Status Bar (try hyprpanel if available in nixpkgs)
      # hyprpanel # Uncomment if available in your nixpkgs version
      
      # Media Codecs
      ffmpegthumbnailer
    ];

    username = "${personal.user}";
    homeDirectory = "${personal.homeDir}";

    # WARN: NEVER Change this value
    stateVersion = "25.05";
  };

  # Spicetify configuration (Community flake module)
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
