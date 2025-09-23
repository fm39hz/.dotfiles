#!/usr/bin/bash

sudo pacman -S git git-lfs
sudo pacman -S gum jq figlet wget unzip
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/main/setup.sh | bash -s -- -s https://raw.githubusercontent.com/fm39hz/.dotfiles/main/com.fm39hz.everland.pkginst com.fm39hz.everland

# Install AUR packages
echo "Installing AUR packages..."
paru -S --needed --noconfirm \
    64gram-desktop-bin \
    7-zip-bin \
    ags-hyprpanel-git \
    anytype-bin \
    app2unit-git \
    appimagelauncher \
    appmenu-glib-translator-git \
    aylurs-gtk-shell-git \
    beekeeper-studio-bin \
    brave-nightly-bin \
    bruno-bin \
    bun-bin \
    calibre-bin \
    carapace \
    colloid-everforest-gtk-theme-git \
    electron37-bin \
    everforest-icon-theme-git \
    flutter-bin \
    gnu-netcat \
    gopreload-git \
    gpu-screen-recorder \
    grimblast-git \
    gruvbox-dark-icons-gtk \
    hyprwayland-scanner-git \
    ibus-bamboo \
    laigter \
    larksuite-bin \
    libastal-4-git \
    libastal-apps-git \
    libastal-auth-git \
    libastal-battery-git \
    libastal-bluetooth-git \
    libastal-cava-git \
    libastal-git \
    libastal-greetd-git \
    libastal-hyprland-git \
    libastal-io-git \
    libastal-meta \
    libastal-mpris-git \
    libastal-network-git \
    libastal-notifd-git \
    libastal-powerprofiles-git \
    libastal-river-git \
    libastal-tray-git \
    libastal-wireplumber-git \
    libcava \
    libinput-gestures \
    libinput-gestures-qt \
    libinput-multiplier \
    lightnovel-crawler-bin \
    localsend-bin \
    luajit-tiktoken-bin \
    matugen-bin \
    microsoft-edge-stable-bin \
    mongodb-tools-bin \
    neofetch \
    nitch-git \
    nmgui-bin \
    nouveau-fw \
    paru-bin \
    paru-debug \
    pm2ml \
    postman-bin \
    powerpill \
    python-gpustat \
    python-nvidia-ml-py \
    python-pywal16 \
    python-pywalfox \
    python3-memoizedb \
    python3-xcgf \
    python3-xcpf \
    pywal-spicetify \
    rtl8821au-dkms-git \
    sendme-bin \
    spicetify-cli \
    spotify \
    spotx-git \
    thorium-browser-bin \
    todoist-appimage \
    tofi \
    ttf-material-icons-git \
    unionfs-fuse \
    vesktop-bin \
    visual-studio-code-bin \
    wlogout \
    yay-bin \
    zen-browser-bin \

echo "AUR packages installation complete!"
