#Install dependencies
sudo pacman -S git npm unzip zsh neofetch 
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
yay -S cliphist hyprland-git waybar-hyprland-git alacritty rofi-lbonn-wayland swww libnotify notification-daemon swaync networkmanager network-manager-applet bluez bluez-utils blueman papirus-icon-theme noto-fonts-emoji lxsession grimblast-git brightnessctl light nwg-look-bin yad sox mint-themes xcursor-simp1e-gruvbox-dark gtklock eww-wayland thunar thunar-archive-plugin thorium-browser xdg-desktop-portal-hyprland ttf-jetbrains-mono-nerd hyprshot lazygit
