#!/bin/bash
# Bootstrap script for setting up a new Arch Linux machine.

set -e

# --- Colors and Emojis ---
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'
BOLD='\e[1m'

SLOTH_EMOJI="🦥"
CHECK_EMOJI="✅"
WARN_EMOJI="⚠️"
ERROR_EMOJI="❌"

# --- Functions for pretty logging ---
log_info() { echo -e "${CYAN}${BOLD}${SLOTH_EMOJI} INFO: ${RESET}${CYAN}$1${RESET}"; }
log_success() { echo -e "${GREEN}${BOLD}${CHECK_EMOJI} SUCCESS: ${RESET}${GREEN}$1${RESET}"; }
log_warn() { echo -e "${YELLOW}${BOLD}${WARN_EMOJI} WARNING: ${RESET}${YELLOW}$1${RESET}"; }
log_error() { echo -e "${RED}${BOLD}${ERROR_EMOJI} ERROR: ${RESET}${RED}$1${RESET}"; exit 1; }
log_step() { echo -e "\n${BLUE}${BOLD}--- STEP: $1 ---
${RESET}"; }

# --- Welcome Banner ---
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"

  _   _      _ _           _ _ _
 | | | | ___| | | ___  ___| | | |
 | |_| |/ _ \ | |/ _ \/ __| | | |
 |  _  |  __/ | |  __/ __| | | |
 |_| |_|\___|_|_|\___||___/_|_|_|

  ${SLOTH_EMOJI}  Your Arch Linux environment, configured with care! ${SLOTH_EMOJI}

EOF
echo -e "${RESET}"

# --- User Configuration ---
NEW_USERNAME="chalkan3"
DOTFILES_DIR="/home/${NEW_USERNAME}/dotfiles"

log_step "Checking Superuser Access (sudo)"
log_info "Checking if you have sudo permissions..."
if ! sudo -v; then
    log_error "Sudo access is required. Please run this script with a user that has sudo privileges."
fi
log_success "Sudo access confirmed!"

log_step "Installing Essential Dependencies (Git, Salt, Python)"
log_info "Ensuring dirmngr is installed for pacman-key..."
sudo pacman -S --noconfirm --needed dirmngr || log_error "Failed to install dirmngr."

log_info "==> Step 1 of 4: Initializing pacman keyring..."
sudo rm -rf /etc/pacman.d/gnupg || log_warn "Could not remove existing pacman keyring directory. Proceeding anyway."
sudo pacman-key --init --verbose || log_error "Failed to initialize pacman keyring. Check permissions of /etc/pacman.d/"

log_info "==> Step 2 of 4: Populating keyring with Arch Linux default keys..."
sudo pacman-key --populate archlinux --verbose || log_error "Failed to populate pacman keyring."

log_info "==> Step 3 of 4: Refreshing server keys (this may take a while)..."
sudo pacman-key --refresh-keys --verbose || log_warn "Failed to refresh pacman keys. This might cause issues with some packages."

log_info "Ensuring 'extra' repository is enabled in pacman.conf..."
sudo sed -i '/^#\[extra\]$/{N;s/#\[extra\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[extra\]\nInclude = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf || log_error "Failed to enable 'extra' repository in pacman.conf."

log_info "==> Step 4 of 4: Forcing package and system update..."
sudo pacman -Syyu --noconfirm || log_error "Failed to update package repositories. Check your internet connection."

# Check if 'salt' package is available after repository sync
if ! pacman -Ss salt &> /dev/null;
then
    log_error "The 'salt' package was not found in your enabled repositories after update. Please ensure the 'extra' repository is enabled in /etc/pacman.conf and your mirrorlist is up-to-date, then try again."
fi

log_info "Preparing the system for bootstrap... This might take a moment. 🦥"
sudo pacman -S --noconfirm --needed git salt python || log_error "Failed to install essential dependencies. Check your connection or repositories."
log_success "Essential dependencies installed!"

log_step "Cloning Your Dotfiles Repository"
if [ ! -d "$DOTFILES_DIR" ]; then
    log_info "Creating home directory for ${NEW_USERNAME} and adjusting permissions..."
    sudo mkdir -p "/home/${NEW_USERNAME}" || log_error "Failed to create home directory for ${NEW_USERNAME}."
    sudo chown "${NEW_USERNAME}":"${NEW_USERNAME}" "/home/${NEW_USERNAME}" || log_error "Failed to adjust permissions for ${NEW_USERNAME}."
    
    log_info "Cloning dotfiles repository to ${DOTFILES_DIR}... 🦥"
    sudo -u "${NEW_USERNAME}" git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR" || log_error "Failed to clone dotfiles repository."
    log_success "Dotfiles repository cloned successfully!"
else
    log_warn "Dotfiles repository already exists in ${DOTFILES_DIR}. Skipping clone."
fi

log_step "Preparing Temporary Pillar for Salt"
log_info "Setting up temporary Pillar for secure user creation..."
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
TEMP_PILLAR_FILE="${TEMP_PILLAR_DIR}/user.sls"

sudo mkdir -p "$TEMP_PILLAR_DIR" || log_error "Failed to create temporary Pillar directory."
sudo chmod 700 "$TEMP_PILLAR_DIR" || log_error "Failed to adjust permissions for temporary directory."

# Write the temporary Pillar file with an empty password hash
# User will be created without a password, and instructed to set it manually.
USER_PASSWORD_HASH="!"

sudo bash -c "cat > \"$TEMP_PILLAR_FILE\" <<EOF
user_password: '$USER_PASSWORD_HASH'
EOF" || log_error "Failed to write temporary Pillar file."

sudo chmod 600 "$TEMP_PILLAR_FILE" || log_error "Failed to adjust permissions for temporary Pillar file."
log_success "Temporary Pillar prepared!"

log_step "Applying Salt States (Main Configuration)"
log_info "Salt is now configuring your system and running tests. Observe the output for test progress... 🦥"
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply || log_error "Failed to apply Salt states or tests failed. Check logs above."
log_success "Salt states applied successfully and all tests passed! Your environment is almost ready!"

log_step "Finalizing and Cleaning Up"
log_info "Removing temporary Pillar files..."
sudo rm -rf "$TEMP_PILLAR_DIR" || log_warn "Failed to remove temporary Pillar files. Manual cleanup might be needed."
log_success "Cleanup complete!"

echo -e "\n${GREEN}${BOLD}${CHECK_EMOJI} SETUP COMPLETE! ${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------${RESET}"
log_step "NEXT STEPS: What to do now?"

log_info "1. Set a password for your new user: ${NEW_USERNAME}"
echo -e "${CYAN}   sudo passwd ${NEW_USERNAME}${RESET}"

log_info "2. Log in as ${NEW_USERNAME}"
echo -e "${YELLOW}   You can switch user in your current terminal or log out and log back in.${RESET}"

log_info "3. Open a new terminal (or restart your shell)"
echo -e "${GREEN}   This will load your new Zsh configuration and start installing plugins via Zinit. This might take a few moments. 🦥${RESET}"

echo -e "\n${GREEN}--------------------------------------------------------------------${RESET}"
