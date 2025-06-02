# ~/.config/nixos/modules/desktop/fonts.nix
{ pkgs, ... }:
{
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
}
