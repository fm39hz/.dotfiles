#Setup config
sudo chown -R $(whoami) ~/
rm -rf ~/.config
git clone git@github.com:fm39hz/.dotfiles.git ~/.config/

#Setup NvChad
git clone git@github.com:fm39hz/NvChad.git ~/.config/nvim/ --depth 1 && nvim

#Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#Symlink script & rc files
ln -s ~/.config/.zshrc ~/.zshrc
sudo ln -s ~/.config/hyprland_autolog.sh /etc/profile.d/hyprland_autolog.sh
