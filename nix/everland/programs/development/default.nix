{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./security.nix
  ];

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      set termguicolors
      set signcolumn=yes
      
      " Use system clipboard
      set clipboard+=unnamedplus
    '';

    plugins = with pkgs.vimPlugins; [
      # Essential plugins would go here
      # Example: nvim-treesitter, telescope-nvim, etc.
    ];
  };

  # Additional development packages
  home.packages = with pkgs; [
    # Text Editor
    neovide
    
    # Network Tools
    iw
    nmap
    cloudflared
    lynx
  ];
}