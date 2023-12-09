pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
yay -S cliphist hyprland-git waybar-hyprland-git alacritty rofi-lbonn-wayland swww libnotify notification-daemon swaync networkmanager network-manager-applet bluez bluez-utils blueman papirus-icon-theme noto-fonts-emoji lxsession grimblast-git brightnessctl light nwg-look-bin yad sox mint-themes xcursor-simp1e-gruvbox-dark gtklock eww-wayland git xdg-desktop-portal-hyprland ttf-jetbrains-mono-nerd neofetch hyprshot
echo "Do you wish to install NvChad? (y/N):"
select yn in "y" "N"; do
    case $yn in
        y ) git clone https://github.com/NvChad/NvChad.git ~/.config/nvim;;
        N ) exit;;


echo "Do you wish to install Oh-my-zsh? (y/N):"
select yn in "y" "N"; do
    case $yn in
        y ) sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; break;;
        N ) exit;;
    esac
done
git clone https://github.com/fm39hz/.dotfiles.git ~/.config

echo "Do you want to autologin to Hyprland with non root account? (y/N):"

select yn in "y" "N"; do
    case $yn in
        y ) cp ~/.config/hyprland_autolog.sh /etc/profile.d/; break;;
        N ) exit;;
    esac
done