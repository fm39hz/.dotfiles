{ pkgs, ... }:

{
  # Yazi file manager configuration
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_symlink = true;
      };
      
      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
      };
      
      opener = {
        edit = [
          { run = "nvim \"$@\""; block = true; }
        ];
        open = [
          { run = "xdg-open \"$@\""; desc = "Open with default application"; }
        ];
        reveal = [
          { run = "xfce.thunar \"$@\""; desc = "Reveal in file manager"; }
        ];
      };
    };

    keymap = {
      manager.prepend_keymap = [
        { on = "T"; run = "plugin --sync max-preview"; desc = "Maximize preview"; }
        { on = "<C-s>"; run = "shell"; desc = "Open shell here"; }
        { on = "y"; run = "yank"; desc = "Copy selected files"; }
        { on = "Y"; run = "unyank"; desc = "Cancel copy"; }
      ];
    };
  };

  # Fonts
  fonts.fontconfig.enable = true;

  # File management packages and fonts
  home.packages = with pkgs; [
    # File Managers
    xfce.thunar
    xfce.thunar-archive-plugin
    superfile
    
    # Archive Tools
    unrar
    unzip
    p7zip
    xarchiver
    
    # System Utilities
    brightnessctl
    ddcutil
    plocate
    rsync
    wget
    acpi
    lshw
    powertop
    
    # Hardware Support
    intel-media-driver
    libva-utils
    
    # Desktop Integration
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    
    # Qt/GTK theming
    libsForQt5.qt5ct
    gtk-engine-murrine
    nwg-look
    
    # GNOME Tools
    gnome-calculator
    gnome-disk-utility
    gnome-bluetooth
    
    # Session Management
    uwsm # Universal Wayland Session Manager (replaces app2unit)
    
    # Compression
    zram-generator
    
    # Documentation
    tldr
    man-db

    # Fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}