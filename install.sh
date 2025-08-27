#!/bin/bash
# Bootstrap script for setting up a new Arch Linux machine.

set -e

# --- User Configuration ---
NEW_USERNAME="chalkan3"
DOTFILES_DIR="/home/${NEW_USERNAME}/dotfiles"

# --- Check for sudo access ---
echo "Checking for sudo access..."
if ! sudo -v;
    then
    echo "Sudo access is required. Please run this script with a user that has sudo privileges."
    exit 1
fi

# --- Install Git and Salt (Arch Linux) ---
echo "Installing dependencies for Arch Linux: git and salt..."
sudo pacman -S --noconfirm --needed git salt python

# --- Clone Dotfiles Repo ---
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    # Create the home directory if it doesn't exist, so git clone can run as the new user
    sudo mkdir -p "/home/${NEW_USERNAME}"
    sudo chown "${NEW_USERNAME}":"${NEW_USERNAME}" "/home/${NEW_USERNAME}"
    # Run git clone as the new user
    sudo -u "${NEW_USERNAME}" git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# --- Prepare Temporary Pillar for Salt (No Password) ---
# User will be created without a password, and instructed to set it manually.
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
TEMP_PILLAR_FILE="${TEMP_PILLAR_DIR}/user.sls"

sudo mkdir -p "$TEMP_PILLAR_DIR"
sudo chmod 700 "$TEMP_PILLAR_DIR"

# Write the temporary Pillar file with an empty password hash
# Salt will create the user without a password, or with a disabled password.
# The user will be prompted to set it after the script finishes.
USER_PASSWORD_HASH="!"
# Using '!' as a password hash typically means the password is disabled or not set.
# Alternatively, one could use 'password_disabled: True' in user.sls if not using passwd field.

sudo bash -c "cat > \"$TEMP_PILLAR_FILE\" <<EOF
user_password: '$USER_PASSWORD_HASH'
EOF"

sudo chmod 600 "$TEMP_PILLAR_FILE"

# --- Apply Salt States ---
echo "Applying Salt states... This may take a while."
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply

# --- Clean up Temporary Pillar ---
sudo rm -rf "$TEMP_PILLAR_DIR"

echo "
Setup complete! User ${NEW_USERNAME} has been created."
echo "Please set a password for ${NEW_USERNAME} by running:"
echo "  sudo passwd ${NEW_USERNAME}"
echo "Then, you can log in as ${NEW_USERNAME} and restart your shell."