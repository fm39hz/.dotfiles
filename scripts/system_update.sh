#!/usr/bin/env fish

# Update system packages using yay
notify-send "System update" "Updating system packages with yay..."
# run0 pacman -Syu --noconfirm
yay --noconfirm

# Update Oh My Fish and any installed plugins
notify-send "System update" "Updating Oh My Fish and plugins..."
omf update

# Remove dangling (orphans)
yay -Qdtq | yay -Rns --noconfirm -

# Snapshot package lists
notify-send "System update" "Snapshotting package lists..."
set today ~/.config/.backup/(date +%Y-%m-%d)
mkdir -p $today

# 1) AUR & local
pacman -Qqm > $today/aurandlocal.lst

# 2) Official repo only
pacman -Qqe | grep -vxF -f $today/aurandlocal.lst > $today/main.lst

# Now generate packages.json as before
set json_path ~/.config/hypr/com.fm39hz.everland/pkginst/packages.json
mkdir -p (dirname $json_path)

echo '{' > $json_path
echo '    "packages": [' >> $json_path

for pkg in (cat $today/main.lst)
    echo "        { \"package\": \"$pkg\" }," >> $json_path
end

# Remove trailing comma from last item
sed -i '$ s/},/}/' $json_path

echo '    ],' >> $json_path
echo '    "options": []' >> $json_path
echo '}' >> $json_path

echo "packages.json generated at $json_path"
cd ~/.config/hypr/ || exit
zip -r ~/.config/com.fm39hz.everland.pkginst com.fm39hz.everland

# Update install.sh with current AUR packages
set install_script ~/.config/scripts/install.sh
echo "Updating install.sh with current AUR packages..."

echo '#!/usr/bin/bash

sudo pacman -S git git-lfs
sudo pacman -S gum jq figlet wget unzip
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/.cache/yay
cd ~/.cache/yay || exit
makepkg -si
curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/main/setup.sh | bash -s -- -s https://raw.githubusercontent.com/fm39hz/.dotfiles/main/com.fm39hz.everland.pkginst com.fm39hz.everland

# Install AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm \\' > $install_script

# Add each AUR package with proper line continuation
for pkg in (cat $today/aurandlocal.lst)
    echo "    $pkg \\" >> $install_script
end

# Remove the last backslash and add completion message
sed -i '$ s/ \\$//' $install_script
echo '' >> $install_script
echo 'echo "AUR packages installation complete!"' >> $install_script

chmod +x $install_script
echo "install.sh updated with "(wc -l < $today/aurandlocal.lst)" AUR packages"

# Update Neovim packages
notify-send "System update" "Updating Nvim packages..."
git pull
cd ~/.config/nvim/ || exit
git checkout master
git pull
nvim --headless "+Lazy! sync" +qa

# Commit & push lazy-lock if changed
if git diff --quiet lazy-lock.json
    notify-send "System update | Neovim" "No changes to commit for Nvim packages."
else
    git add lazy-lock.json
    git commit -m "chore: update deps"
    git push
end

# Refresh Go preload cache
gopreload-batch-refresh.sh

# Update Hyprland plugins
notify-send "System update" "Updating Hyprland plugins..."
hyprpm update

cd ~/.config/ || exit
notify-send "System update" "Update Complete!"
