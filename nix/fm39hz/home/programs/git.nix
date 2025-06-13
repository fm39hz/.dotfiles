# ~/.config/nixos/home/programs/git.nix (MISSING)
{ ... }:
{
  programs.git = {
    enable = true;
    userName = "FM39hz";
    userEmail = "your-email@example.com";
    extraConfig = {
      core.attributesfile = "~/.config/git/.gitattribute";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
