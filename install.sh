#!/bin/bash
# Bootstrap script for setting up a new machine.

set -e

# --- Check for sudo ---
echo "Checking for sudo access..."
if ! sudo -v; then
    echo "Sudo access is required. Please run this script with a user that has sudo privileges."
    exit 1
fi

# --- Install Git and Salt --- 
echo "Installing dependencies: git and salt..."
if command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm git salt
elif command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y git salt-minion
elif command -v dnf &> /dev/null; then
    sudo dnf install -y git salt-minion
else
    echo "Unsupported package manager. Please install git and salt manually."
    exit 1
fi

# --- Clone Dotfiles Repo ---
DOTFILES_DIR="/home/igor/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# --- Apply Salt States ---
echo "Applying Salt states... This may take a while."
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" state.apply

echo "
Setup complete! Please restart your shell or source your .zshrc file.
"
