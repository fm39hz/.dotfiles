{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = "10s";
      };
    };
  };

  # Development environment packages
  home.packages = with pkgs; [
    # Development Tools
    lazydocker
    
    # Programming Languages & Runtimes
    nodejs # alias to latest LTS
    python3
    python3Packages.pip
    rustc
    cargo
    go
    openjdk17 # or temurin-bin-17
    dotnetCorePackages.sdk_8_0
    lua5_1
    luarocks
    nasm
    
    # Build Tools
    cmake
    ninja
    maven
    clang
    
    # Web Development
    dart-sass
    
    # Text Processing
    yq
    html-xml-utils
    tree-sitter
    
    # Development Utilities
    libfaketime
  ];
}