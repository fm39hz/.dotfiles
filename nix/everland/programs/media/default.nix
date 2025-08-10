{ pkgs, inputs, ... }:

{
  imports = [
    ./obs.nix
    ./zathura.nix
  ];

  # Additional media packages
  home.packages = with pkgs; [
    # Video/Audio
    vlc
    sox
    ffmpegthumbnailer
    
    # Graphics
    gimp
    blender
    imagemagick
    chafa
    
    # Productivity
    obsidian
    libreoffice-fresh
    bitwarden
    
    # Communication
    _64gram # 64gram-desktop-bin equivalent
    vesktop # Discord alternative with Vencord  
    
    # Development Tools
    vscode # visual-studio-code-bin equivalent
    mongodb-compass
    
    # Scientific Computing
    plantuml
    graphviz
    
    # Game Development
    tiled
  ];

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