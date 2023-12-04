pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
yay -S cliphist hyprland-git waybar-hyprland-git alacritty rofi-lbonn-wayland swww libnotify notification-daemon swaync networkmanager network-manager-applet bluez bluez-utils blueman papirus-icon-theme noto-fonts-emoji lxsession grimblast-git brightnessctl light nwg-look-bin yad sox 
mint-themes xcursor-simp1e-gruvbox-dark gtklock eww-wayland git xdg-desktop-portal-hyprland ttf-jetbrains-mono-nerd neofetch hyprshot zsh nitch lazygit

#Setup config
rm -rf ~/.config
git clone https://github.com/fm39hz/.dotfiles.git ~/.config/
mkdir ~/.config/backup

#Setup NvChad
cp ~/.config/nvim/lua/custom ~/.config/backup/nvim/lua/custom
rm -rf ~/.config/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
rm -rf ~/.config/nvim/lua/custom 
cp ~/.config/backup/nvim/lua/custom ~/.config/nvim/lua/custom 

#Setup Shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
ln -s ~/.config/.zshrc ~/.zshrc
