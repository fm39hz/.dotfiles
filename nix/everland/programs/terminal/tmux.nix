{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-a";
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      catppuccin
    ];

    extraConfig = ''
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Enable mouse mode
      set -g mouse on

      # Don't rename windows automatically
      set-option -g allow-rename off

      # Set default terminal mode to 256color mode
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      # History limit
      set -g history-limit 10000

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };
}