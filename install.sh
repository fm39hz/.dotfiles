#Install dependencies
sudo pacman -S git npm unzip zsh neofetch 
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
yay -S cliphist hyprland-git waybar-hyprland kitty rofi-lbonn-wayland swww libnotify notification-daemon swaync networkmanager network-manager-applet bluez bluez-utils blueman noto-fonts-emoji lxsession grimblast-git brightnessctl lightdm nwg-look-bin yad sox gruvbox-{dark-icons-gtk,material-gtk-theme-git} xcursor-simp1e-gruvbox-dark gtklock eww-wayland thunar thunar-archive-plugin thorium-browser xdg-desktop-portal-hyprland ttf-jetbrains-mono-nerd hyprshot lazygit
