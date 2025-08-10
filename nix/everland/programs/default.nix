{ ... }:

{
  imports = [
    ./git.nix
    ./shells
    ./terminal
    ./browsers
    ./media
    ./development
    ./input.nix
    ./files.nix
    ./waybar.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
  ];
}