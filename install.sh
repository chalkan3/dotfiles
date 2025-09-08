#!/bin/bash
# Bootstrap script for setting up a new macOS or Ubuntu machine.

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
log_step() { echo -e "\n${BLUE}${BOLD}--- STEP: $1 ---\n${RESET}"; }

# --- Welcome Banner ---
# --- Welcome Banner ---
if command -v figlet &>/dev/null; then
  echo -e "${GREEN}${BOLD}"
  figlet "树懒"
  echo -e "${RESET}"
else
  echo -e "${GREEN}${BOLD}
  树懒
${RESET}"
fi
echo -e "${CYAN}  ${SLOTH_EMOJI}  Your development environment, configured with care! ${SLOTH_EMOJI}${RESET}"


# --- User and OS Configuration ---
if [ -n "$SUDO_USER" ]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER=$(whoami)
fi
REAL_HOME=$(eval echo "~$REAL_USER")
DOTFILES_DIR="$REAL_HOME/dotfiles"

# --- OS Detection ---
OS_FAMILY=""
if [[ "$(uname)" == "Darwin" ]]; then
    OS_FAMILY="macos"
elif [[ -f /etc/lsb-release || -f /etc/debian_version ]]; then
    OS_FAMILY="ubuntu"
elif [[ -f /etc/arch-release ]]; then
    OS_FAMILY="arch"
else
    log_error "Unsupported operating system. This script supports macOS, Ubuntu, and Arch Linux."
fi
log_info "Detected OS Family: $OS_FAMILY"

# --- Dependency Installation Functions ---
install_deps_ubuntu() {
    log_info "Checking Ubuntu dependencies..."
    sudo apt-get update || log_warn "Could not update apt package lists."

    
    
    local missing_deps=()
    local deps_to_check=(git salt-minion python3 python3-pip stow figlet)
    for dep in "${deps_to_check[@]}"; do
        if ! dpkg -s "$dep" &>/dev/null;
        then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}..."

        # Special handling for salt-minion if it's missing
        local salt_minion_installed=false
        if [[ " ${missing_deps[*]} " =~ " salt-minion " ]]; then
            log_info "Attempting to install salt-minion via bootstrap script..."
            if curl -L https://bootstrap.saltproject.io -o /tmp/install_salt.sh && \
               sudo bash /tmp/install_salt.sh -P -N stable; then
                log_success "salt-minion installed successfully via bootstrap script."
                # Remove salt-minion from missing_deps so apt doesn't try again
                missing_deps=( "${missing_deps[@]/salt-minion}" )
                salt_minion_installed=true
            else
                log_warn "Failed to install salt-minion via bootstrap script. Will try apt-get."
            fi
            rm -f /tmp/install_salt.sh # Clean up the bootstrap script
        fi

        

        # Install remaining missing dependencies via apt-get
        if [ ${#missing_deps[@]} -gt 0 ]; then
            sudo apt-get install -y "${missing_deps[@]}" || log_error "Failed to install remaining dependencies."
        
        fi
    else
        log_success "All essential dependencies are already installed."
    fi
}

install_deps_arch() {
    log_info "Checking Arch Linux dependencies..."
    sudo pacman -Sy --noconfirm || log_warn "Could not update pacman package lists."

    local missing_deps=()
    local deps_to_check=(git salt python python-pip stow)
    for dep in "${deps_to_check[@]}"; do
        if ! pacman -Q "$dep" &>/dev/null;
        then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}..."
        sudo pacman -S --noconfirm "${missing_deps[@]}" || log_error "Failed to install dependencies."
    else
        log_success "All essential dependencies are already installed."
    fi
}

install_deps_macos() {
    if ! command -v brew &>/dev/null;
    then
        log_warn "Homebrew not found. Attempting to install..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || log_error "Failed to install Homebrew."
    else
        log_success "Homebrew is already installed."
    fi

    log_info "Checking Homebrew dependencies..."
    brew update || log_warn "Failed to update Homebrew."

    local missing_deps=()
    local deps_to_check=(git salt python stow)
    local installed_formulae
    installed_formulae=$(brew list --formula)

    for dep in "${deps_to_check[@]}"; do
        if ! echo "$installed_formulae" | grep -q "^${dep}"$; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}..."
        brew install "${missing_deps[@]}" || log_error "Failed to install dependencies via Homebrew."
    else
        log_success "All essential dependencies are already installed."
    fi
}

log_step "Installing Essential Dependencies"
if [ "$OS_FAMILY" = "ubuntu" ]; then
    install_deps_ubuntu
elif [ "$OS_FAMILY" = "macos" ]; then
    install_deps_macos
elif [ "$OS_FAMILY" = "arch" ]; then
    install_deps_arch
fi





# Create temporary Salt config directory for initial bootstrap
TEMP_SALT_CONFIG_DIR="/tmp/salt_temp_config"
sudo mkdir -p "$TEMP_SALT_CONFIG_DIR" || log_error "Failed to create temporary Salt config directory."
sudo chmod 700 "$TEMP_SALT_CONFIG_DIR" || log_error "Failed to adjust permissions for temporary Salt config directory."

# Create temporary minion.conf for initial bootstrap
sudo bash -c "cat > $TEMP_SALT_CONFIG_DIR/minion.conf <<EOL
# Temporary Salt-minion configuration for initial bootstrap
file_client: local

file_roots:
  base:
    - $(pwd)/salt/roots/salt

pillar_roots:
  base:
    - $(pwd)/salt/roots/pillar
EOL" || log_error "Failed to write temporary minion.conf."
sudo chmod 600 "$TEMP_SALT_CONFIG_DIR/minion.conf" || log_error "Failed to adjust permissions for temporary minion.conf."

log_step "Applying Salt States (Main Configuration)"
log_info "Installing Salt dependencies"
sudo pip install contextvars # Ensure contextvars is available for salt-call
log_info "Salt is now configuring your system. This may take a while... 🦥"

# Create temporary pillar file
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
sudo mkdir -p "$TEMP_PILLAR_DIR" || log_error "Failed to create temporary Pillar directory."
sudo chmod 700 "$TEMP_PILLAR_DIR" || log_error "Failed to adjust permissions for temporary directory."
sudo bash -c "cat > $TEMP_PILLAR_DIR/user_details.sls <<EOF
user: '$REAL_USER'
home: '$REAL_HOME'
EOF" || log_error "Failed to write temporary Pillar file."
sudo chmod 600 "$TEMP_PILLAR_DIR/user_details.sls" || log_error "Failed to adjust permissions for temporary Pillar file."

log_info "Applying initial Salt states (packages, user, ssh hardening)..."
sudo salt-call --local --config-dir="$TEMP_SALT_CONFIG_DIR" --pillar-root="$TEMP_PILLAR_DIR" state.apply top_initial -l debug || log_error "Failed to apply initial Salt states. Check logs above."
log_success "Initial Salt states applied successfully!"

log_step "Applying Dotfiles and Final Configuration for chalkan3"
log_info "Applying dotfiles and final configurations for user 'chalkan3'..."
# We need to run this as chalkan3, but salt-call needs sudo.
# The dotfiles.sls state is designed to run stow as chalkan3.
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply top -l debug || log_error "Failed to apply dotfiles and final configurations. Check logs above."
log_success "Dotfiles and final configurations applied successfully for chalkan3!"

log_step "Setting Zsh as Default Shell"
if command -v zsh &>/dev/null;
then
    ZSH_PATH=$(command -v zsh)
    CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        log_info "Changing default shell to Zsh for '${REAL_USER}'..."
        if sudo chsh -s "$ZSH_PATH" "$REAL_USER"; then
            log_success "Default shell changed to Zsh!"
            log_info "For the change to take effect, you will need to log out and log back in."
        else
            log_warn "Failed to automatically change the shell. You may need to run the following command manually:"
            log_warn "sudo chsh -s $(command -v zsh) ${REAL_USER}"
        fi
    else
        log_info "Zsh is already the default shell for '${REAL_USER}'."
    fi
else
    log_warn "Zsh command not found. Skipping setting it as default."
fi

log_step "Finalizing and Cleaning Up"
log_info "Removing temporary Pillar files..."
sudo rm -rf "$TEMP_PILLAR_DIR" || log_warn "Failed to remove temporary Pillar files. Manual cleanup might be needed."
log_info "Removing temporary Salt config directory..."
sudo rm -rf "$TEMP_SALT_CONFIG_DIR" || log_warn "Failed to remove temporary Salt config directory. Manual cleanup might be needed."
log_success "Cleanup complete!"

echo -e "\n${GREEN}${BOLD}${CHECK_EMOJI} SETUP COMPLETE! ${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------
${RESET}"
log_step "NEXT STEPS: What to do now?"

log_info "1. Open a new terminal (or restart your shell)"
echo -e "${GREEN}   This will load your new Zsh configuration and start installing plugins. This might take a few moments. 🦥${RESET}"

echo -e "\n${GREEN}--------------------------------------------------------------------
${RESET}"