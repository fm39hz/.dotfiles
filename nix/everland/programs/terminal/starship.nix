{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      # Use everforest-style prompt based on existing config
      format = ''
        $os\
        $username\
        $hostname\
        [](bg:color_yellow fg:color_green)\
        $directory\
        [](fg:color_yellow bg:color_aqua)\
        $git_branch\
        $git_status\
        [](fg:color_aqua bg:color_blue)\
        $c\
        $rust\
        $golang\
        $nodejs\
        $php\
        $java\
        $kotlin\
        $haskell\
        $python\
        [](fg:color_blue bg:color_bg3)\
        $docker_context\
        $conda\
        [](fg:color_bg3 bg:transparent)\
        $line_break$character'';

      # palette = "everforest_dark";
      #
      # # Everforest color palette
      # palettes.everforest_dark = {
      #   color_fg0 = "#d3c6aa";
      #   color_bg1 = "#2e3440";
      #   color_bg3 = "#374145";
      #   color_blue = "#7fbbb3";
      #   color_aqua = "#83c092";
      #   color_green = "#a7c080";
      #   color_orange = "#e69875";
      #   color_purple = "#d699b6";
      #   color_red = "#e67e80";
      #   color_yellow = "#dbbc7f";
      #   color_pink = "#d699b6";
      # };

      # Module configurations
      os = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";
      };

      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };

      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
      };

      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_green)";
        error_symbol = "[](bold fg:color_red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };

      line_break = {
        disabled = false;
      };
    };
  };
}
