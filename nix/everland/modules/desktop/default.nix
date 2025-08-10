{ ... }:
{
  imports = [
    # Choose one theming approach:
    ./stylix.nix  # Hybrid Stylix + custom themes (recommended)
    # ./theme.nix        # Pure custom theming (current)
    ./hyprland
  ];
}
