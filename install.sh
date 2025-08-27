#!/bin/bash
# Bootstrap script for setting up a new Arch Linux machine.

set -e

# --- Check for sudo access ---
echo "Checking for sudo access..."
if ! sudo -v; then
    echo "Sudo access is required. Please run this script with a user that has sudo privileges."
    exit 1
fi

# --- Install Git and Salt (Arch Linux) --- 
echo "Installing dependencies for Arch Linux: git and salt..."
sudo pacman -S --noconfirm --needed git salt

# --- Clone Dotfiles Repo ---
# Assumes the user running the script is 'igor'
DOTFILES_DIR="/home/igor/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    # Run git clone as the user, not as root
    sudo -u igor git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# --- Apply Salt States ---
echo "Applying Salt states... This may take a while."
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" state.apply

echo "
Setup complete! Please restart your shell or source your .zshrc file.
"