#!/bin/bash
# install.sh - A script to set up the dotfiles.

# Variables
DOTFILES_DIR=~/dotfiles
BACKUP_DIR=~/dotfiles_backup
FILES=(".zshrc" ".zsh" ".p10k.zsh")

# Create backup directory if it doesn't exist
echo "Creating backup directory at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Move any existing dotfiles in homedir to backup directory, then create symlinks
echo "Moving existing dotfiles from ~ to $BACKUP_DIR..."
for file in "${FILES[@]}"; do
    if [ -e "$HOME/$file" ]; then
        echo "Backing up $file..."
        mv "$HOME/$file" "$BACKUP_DIR/"
    fi
    echo "Creating symlink for $file..."
    ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
done

echo "✅ Dotfiles setup complete. Please restart your shell."
