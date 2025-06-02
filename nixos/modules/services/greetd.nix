# ~/.config/nixos/modules/services/greetd.nix
{ ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "uwsm start hyprland.desktop";
        user = "fm39hz";
      };
      terminal.vt = 1;
    };
  };
}
