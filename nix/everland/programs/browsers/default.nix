{ pkgs, inputs, ... }:

{
  imports = [
    ./firefox.nix
    ./chromium.nix
  ];

  # Additional browsers from packages and community flakes
  home.packages = with pkgs; [
    brave
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    # inputs.thorium-browser.packages.${pkgs.stdenv.hostPlatform.system}.thorium-browser
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}