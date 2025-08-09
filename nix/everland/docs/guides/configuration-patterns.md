# NixOS Configuration Patterns & Examples

## Common Configuration Patterns

### Multi-Host Configuration
```nix
# flake.nix
{
  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          ./common/base.nix
        ];
      };
      
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          ./common/base.nix
          ./common/laptop.nix
        ];
      };
    };
  };
}
```

### Shared Configuration Modules
```nix
# common/base.nix
{ config, pkgs, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    htop
  ];

  # Common services
  services.openssh.enable = true;
  programs.zsh.enable = true;
}
```

### User-Specific Configurations
```nix
# users/alice.nix
{ config, pkgs, ... }:

{
  users.users.alice = {
    isNormalUser = true;
    description = "Alice";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Home Manager integration
  home-manager.users.alice = import ../home/alice.nix;
}
```

### Hardware-Specific Configurations
```nix
# hardware/gpu-nvidia.nix
{ config, pkgs, ... }:

{
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # OpenGL support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
```

## Development Environment Patterns

### Language-Specific Environments
```nix
# dev/rust.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];

  # Development shell
  shell = pkgs.mkShell {
    buildInputs = with pkgs; [
      rustc
      cargo
      pkg-config
      openssl
    ];
    
    shellHook = ''
      echo "Rust development environment loaded"
    '';
  };
}
```

### Project-Specific Shells
```nix
# shell.nix for a Node.js project
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_20
    npm
    yarn
    nodePackages.typescript
    nodePackages.eslint
  ];
  
  shellHook = ''
    echo "Node.js ${pkgs.nodejs_20.version} environment"
    npm install
  '';
}
```

## Service Configuration Patterns

### Web Server Setup
```nix
# services/nginx.nix
{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "example.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Firewall configuration
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  
  # SSL certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@example.com";
  };
}
```

### Database Services
```nix
# services/postgresql.nix
{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql/15";
    
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 md5
      host all all ::1/128 md5
    '';
    
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE myuser WITH LOGIN PASSWORD 'mypassword' CREATEDB;
      CREATE DATABASE mydatabase;
      GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
    '';
  };
}
```

## Desktop Environment Patterns

### Hyprland Configuration
```nix
# desktop/hyprland.nix
{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    hyprpaper
    hypridle
    hyprlock
    hyprshot
  ];

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
```

### Theme Management with Stylix
```nix
# theming/stylix.nix
{ config, pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    image = pkgs.fetchurl {
      url = "https://example.com/wallpaper.jpg";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
  };
}
```

## Security Configuration Patterns

### Firewall Setup
```nix
# security/firewall.nix
{ config, pkgs, ... }:

{
  # Basic firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ ];
    
    # Custom rules
    extraCommands = ''
      iptables -A INPUT -i lo -j ACCEPT
      iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    '';
  };

  # Fail2ban
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "24h";
  };
}
```

### SSH Hardening
```nix
# security/ssh.nix
{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      Protocol = 2;
      X11Forwarding = false;
    };
    
    # Key-based authentication only
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
  };

  # Install authorized keys
  users.users.alice.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB... alice@computer"
  ];
}
```

## Package Override Patterns

### Custom Package Versions
```nix
# overlays/custom-packages.nix
final: prev: {
  # Override existing package
  mypackage = prev.mypackage.override {
    enableFeature = true;
    someFlag = false;
  };

  # Override with different version
  nodejs = prev.nodejs_20;

  # Custom derivation
  my-custom-tool = prev.stdenv.mkDerivation {
    pname = "my-custom-tool";
    version = "1.0.0";
    
    src = prev.fetchFromGitHub {
      owner = "myuser";
      repo = "my-tool";
      rev = "v1.0.0";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    
    buildInputs = with prev; [ cmake ];
    
    installPhase = ''
      mkdir -p $out/bin
      cp my-tool $out/bin/
    '';
  };
}
```

### Package Collections
```nix
# collections/development.nix
{ config, pkgs, ... }:

let
  developmentPackages = with pkgs; [
    # Version control
    git
    git-lfs
    lazygit
    
    # Editors
    neovim
    vscode
    
    # Languages
    nodejs_20
    python3
    rustc
    cargo
    go
    
    # Tools
    docker
    docker-compose
    kubectl
    terraform
  ];
in
{
  environment.systemPackages = developmentPackages;
  
  # Enable Docker
  virtualisation.docker.enable = true;
  users.users.alice.extraGroups = [ "docker" ];
}
```

## Conditional Configuration Patterns

### Host-Specific Options
```nix
{ config, lib, pkgs, ... }:

{
  # Laptop-specific configuration
  powerManagement = lib.mkIf (config.networking.hostName == "laptop") {
    enable = true;
    powertop.enable = true;
  };

  # Desktop-specific configuration
  services.xserver.videoDrivers = lib.mkIf (config.networking.hostName == "desktop") [ "nvidia" ];

  # Environment-specific packages
  environment.systemPackages = with pkgs; [
    # Common packages
    firefox
    git
  ] ++ lib.optionals (config.networking.hostName == "workstation") [
    # Work-specific packages
    slack
    zoom-us
  ] ++ lib.optionals (config.networking.hostName == "gaming") [
    # Gaming-specific packages
    steam
    lutris
  ];
}
```

### Architecture-Specific Configuration
```nix
{ config, lib, pkgs, ... }:

{
  # x86_64-specific packages
  environment.systemPackages = with pkgs;
    lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      steam
      wine
    ] ++
    # AArch64-specific packages
    lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-linux") [
      # ARM-specific tools
    ];
}
```

These patterns provide a foundation for organizing and scaling NixOS configurations effectively.