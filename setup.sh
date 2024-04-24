#Setup config
sudo chown -R $(whoami) ~/
rm -rf ~/.config
git clone git@github.com:fm39hz/.dotfiles.git ~/.config/

#Setup NvChad
git clone git@github.com:fm39hz/NvChad.git ~/.config/nvim-nvchad/ --depth 1 && nvim

#Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#Start service
sudo systemctl enable greetd.service
sudo systemctl enable bluetooth.service

#Symlink script & rc files
ln -s ~/.config/.zshrc ~/.zshrc
ln -s ~/.config/nvim-nvchad ~/.config/nvim
ln -s ~/.local/share/nvim-nvchad ~/.local/share/nvim
ln -s ~/.local/state/nvim-nvchad ~/.local/state/nvim
ln -s ~/.cache/nvim-nvchad ~/.cache/nvim
sudo ln -S ~/.config/greetd/config.toml /etc/greetd/config.toml
sudo ln -s ~/.config/hyprland_autolog.sh /etc/profile.d/hyprland_autolog.sh
