{ pkgs, ... }:

{
  programs.nushell = {
    enable = true;
    
    configFile.text = ''
      # Nushell configuration
      let-env config = {
        show_banner: false
        edit_mode: vi
        shell_integration: true
        
        table: {
          mode: rounded
          index_mode: always
          trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
          }
        }
        
        explore: {
          help_banner: true
          exit_esc: true
          command_bar_text: '#C4C9C6'
          status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6'}
          table: {
            split_line: '#404040'
            cursor: true
            line_index: true
            line_shift: true
            line_head_top: true
            line_head_bottom: true
          }
        }
      }
      
      # Custom aliases
      alias ll = ls -la
      alias la = ls -a
      alias vi = nvim
      alias vim = nvim
    '';

    envFile.text = ''
      # Environment variables
      let-env EDITOR = "nvim"
      let-env BROWSER = "firefox"
    '';
  };
}