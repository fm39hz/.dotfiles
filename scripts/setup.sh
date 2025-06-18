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

# Setup omf
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# Setup keyd
sudo systemctl enable keyd
sudo cp ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl restart keyd
sudo keyd reload

# Setup Cursor
mkdir ~/.icons/
wget -cO- https://github.com/talwat/everforest-cursors/releases/latest/download/everforest-cursors-variants.tar.bz2 | tar xfj - -C ~/.icons
cd ~/.icons || exit
hyprcursor-util -x ~/.icons/everforest-cursors/ -o ./
hyprcursor-util -c ~/.icons/extracted_everforest-cursors/

# Setup Hyprland plugins
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm add https://github.com/shezdy/hyprsplit
hyprpm add https://github.com/KZDKM/Hyprspace

# Setup Neovim distro
git submodule update --init
git submodule sync
# git clone git@github.com:fm39hz/nvim-nvchad.git --depth 1
git clone git@github.com:fm39hz/nvim-lazyvim.git --depth 1
~/.config/scripts/nvim_default_picker.sh
nvim
cd ~/.local/share/nvim/mason/packages/omnisharp/ || return
ln -s OmniSharp omnisharp
cd || return

# Setup yazi
ya pkg install

# Start service
sudo systemctl enable greetd.service
sudo systemctl enable bluetooth.service

# Symlink script & rc files
sudo ln -S ~/.config/greetd/config.toml /etc/greetd/config.toml
# sudo ln -s ~/.config/scripts/hyprland_autolog.sh /etc/profile.d/hyprland_autolog.sh

# Config global gitattributes
git config --global core.attributesfile ~/.config/git/.gitattribute
