{ pkgs, ... }:

{
  # Terminal tools and utilities
  programs.ripgrep.enable = true;
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--ansi"
      "--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
    ];
  };
  
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "everforest-dark-medium";
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "cpu mem net proc";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      show_coretemp = true;
      temp_scale = "celsius";
      force_tty = false;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      proc_gradient = true;
      proc_per_core = false;
      check_temp = true;
      draw_clock = "%X";
      background_update = true;
      custom_cpu_name = "";
      disks_filter = "";
      mem_graphs = true;
      swap_disk = true;
      show_swap = true;
      swap_graphs = true;
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = false;
      show_battery = true;
      show_init = false;
      update_check = false;
    };
  };

  # Terminal packages that don't have program configurations
  home.packages = with pkgs; [
    tree
    fd
    thefuck
    vivid
    gum
    figlet
    cmatrix
    zellij
    htop
    speedtest-cli
    entr
    neofetch
  ];
}