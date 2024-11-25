#!/usr/bin/env fish

# Update system packages using yay
echo "Updating system packages with yay..."
yay --noconfirm

# Update Oh My Fish and any installed plugins
echo "Updating Oh My Fish and plugins..."
omf update

echo "Updating Nvim packages..."
nvim --headless "+Lazy! sync" +qa
cd ~/.config/nvim/ || exit

# Check if there are any changes to commit
if git diff --quiet lazy-lock.json
    echo "No changes to commit for Nvim packages."
else
    git pull
    git add lazy-lock.json
    git commit -m "chore: update deps"
    git push
end

echo "Update Complete!"
