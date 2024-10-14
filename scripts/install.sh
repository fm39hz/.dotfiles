#Install dependencies
sudo pacman -S git git-lfs diff-so-fancy npm fish neofetch
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin

# WM
yay -S hyprland-git hyprcursor hypridle hyprlock hyprshot xdg-desktop-portal-hyprland eww wbg qiv swaync thunar
# Libs
yay -S libnotify notification-daemon networkmanager network-manager-applet bluez bluez-utils man-db lxsession brightnessctl yad sox ibus fcitx5-bamboo
# Themes
yay -S everforest-icon-themes-git
# Fonts
yay -S noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-roboto noto-fonts noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts ttf-dejavu
# Utilities
yay -S waybar kitty rofi-lbonn-wayland-git greetd blueman xclip ripgrep wireplumber neovim nwg-look-bin btop zathura lazygit nitch-git fzf tmux unarchiver unrar unzip yazi zoxide fcitx5-configtool keyd
# Entertainment
yay -S spotify
# Plugins
yay -S zathura-pdf-mupdf thunar-archive-plugin spicetify spotx-linux
# Development
yay -S docker docker-buildx docker-compose dotnet-sdk dotnet-sdk-7.0 aspnet-runtime mono python-pip
