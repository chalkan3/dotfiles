#!/bin/bash
# Bootstrap script for setting up a new Arch Linux machine.

set -e

# --- User Configuration ---
NEW_USERNAME="chalkan3"
DOTFILES_DIR="/home/${NEW_USERNAME}/dotfiles"

# --- Check for sudo access ---
echo "Checking for sudo access..."
if ! sudo -v; then
    echo "Sudo access is required. Please run this script with a user that has sudo privileges."
    exit 1
fi

# --- Prompt for User Password ---
read -s -p "Enter password for user ${NEW_USERNAME}: " USER_PASSWORD
echo
read -s -p "Confirm password for user ${NEW_USERNAME}: " USER_PASSWORD_CONFIRM
echo

if [ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]; then
    echo "Passwords do not match. Exiting."
    exit 1
fi

# Generate password hash (SHA512)
# Requires python-passlib or similar for crypt.crypt to work with METHOD_SHA512
# On Arch, python-passlib is usually not needed for crypt.crypt
USER_PASSWORD_HASH=$(python -c "import crypt; print(crypt.crypt('$USER_PASSWORD', crypt.METHOD_SHA512))" 2>/dev/null)
if [ -z "$USER_PASSWORD_HASH" ]; then
    echo "Error generating password hash. Ensure Python's crypt module supports SHA512."
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

# --- Prepare Temporary Pillar for Salt ---
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
TEMP_PILLAR_FILE="${TEMP_PILLAR_DIR}/user.sls"

sudo mkdir -p "$TEMP_PILLAR_DIR"
sudo chmod 700 "$TEMP_PILLAR_DIR"

# Write the temporary Pillar file with the password hash
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
Setup complete! Please log in as ${NEW_USERNAME} with the password you provided.
"
