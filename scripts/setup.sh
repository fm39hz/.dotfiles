# Setup config
sudo chown -R "$(whoami)" ~/
rm -rf ~/.config
git clone git@github.com:fm39hz/.dotfiles.git ~/.config/

# Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
ln -s ~/.config/.zshrc ~/.zshrc

# Setup Neovim distro
git submodule update --init
git submodule sync
# git clone git@github.com:fm39hz/nvim-nvchad.git --depth 1
# git clone git@github.com:fm39hz/nvim-lazyvim.git --depth 1
~/.config/scripts/nvim_default_picker.sh

# Start service
sudo systemctl enable greetd.service
sudo systemctl enable bluetooth.service

# Symlink script & rc files
sudo ln -S ~/.config/greetd/config.toml /etc/greetd/config.toml
sudo ln -s ~/.config/scripts/hyprland_autolog.sh /etc/profile.d/hyprland_autolog.sh
