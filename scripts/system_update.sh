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
for pkg in (cat $today/aurandlocal.lst)
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
