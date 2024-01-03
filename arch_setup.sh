#Setup config
rm -rf ~/.config
git clone git@github.com:fm39hz/.dotfiles.git ~/.config/
mkdir -p ~/.config/backup/nvim/lua/custom

#Setup NvChad
cp ~/.config/nvim/lua/custom ~/.config/backup/nvim/lua/custom -r
rm -rf ~/.config/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
rm -rf ~/.config/nvim/lua/custom 
cp ~/.config/backup/nvim/lua/custom ~/.config/nvim/lua/custom -r

#Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#Symlink script & rc files
ln -s ~/.config/.zshrc ~/.zshrc
sudo ln -s ~/.config/hyprland_autolog.sh /etc/profile.d/hyprland_autolog.sh
