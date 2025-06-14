{ personal, pkgs,... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    image = "${personal.homeDir}/Pictures/Wallpaper/ForestStairCase.png";
  };
}
