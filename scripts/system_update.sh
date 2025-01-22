#!/usr/bin/env fish

# Update system packages using yay
echo "Updating system packages with yay..."
yay --noconfirm

# Update Oh My Fish and any installed plugins
echo "Updating Oh My Fish and plugins..."
omf update

echo "Updating Nvim packages..."
git pull
cd ~/.config/nvim/ || exit
git checkout master
git pull
nvim --headless "+Lazy! sync" +qa

# Check if there are any changes to commit
if git diff --quiet lazy-lock.json
    echo "No changes to commit for Nvim packages."
else
    git add lazy-lock.json
    git commit -m "chore: update deps"
    git push
end

echo "Update Complete!"
