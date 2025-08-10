{ pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      user.name = "fm39hz";
      user.email = "your-email@example.com"; # Update with your email
    };
  };

  programs.lazygit.enable = true;
  
  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      editor = "nvim";
    };
  };

  # Git-related packages
  home.packages = with pkgs; [
    diff-so-fancy
  ];
}