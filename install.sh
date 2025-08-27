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
log_step() { echo -e "\n${BLUE}${BOLD}--- STEP: $1 ---${RESET}"; }

# --- Welcome Banner ---
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"

  _   _      _ _           _ _ _
 | | | | ___| | | ___  ___| | | |
 | |_| |/ _ \ | |/ _ \/ __| | | |
 |  _  |  __/ | |  __/<strong></strong>__ \ | | |
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
log_info "Salt is now configuring your system. This might take a while... 🦥"
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply || log_error "Failed to apply Salt states. Check logs above."
log_success "Salt states applied successfully! Your environment is almost ready!"

log_step "Finalizing and Cleaning Up"
log_info "Removing temporary Pillar files..."
sudo rm -rf "$TEMP_PILLAR_DIR" || log_warn "Failed to remove temporary Pillar files. Manual cleanup might be needed."
log_success "Cleanup complete!"

echo -e "\n${GREEN}${BOLD}${CHECK_EMOJI} SETUP COMPLETE! ${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------
${RESET}"
echo -e "${GREEN}User ${NEW_USERNAME} has been created. ${RESET}"
echo -e "${YELLOW}⚠️  Please set a password for ${NEW_USERNAME} by running:${RESET}"
echo -e "  sudo passwd ${NEW_USERNAME}${RESET}"
echo -e "${GREEN}After setting the password, you can log in as ${NEW_USERNAME} and restart your shell.${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------
${RESET}"