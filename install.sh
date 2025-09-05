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
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"

  _   _      _ _           _ _ _
 | | | | ___| | | ___  ___| | | |
 | |_| |/ _ \ | |/ _ \/ __| | | |
 |  _  |  __/ | |  __/ __| | | |
 |_| |_|\___|_|_|\___||___/_|_|_|

  ${SLOTH_EMOJI}  Your development environment, configured with care! ${SLOTH_EMOJI}

EOF
echo -e "${RESET}"

# --- User and OS Configuration ---
if [ -n "$SUDO_USER" ]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER=$(whoami)
fi
REAL_HOME=$(eval echo "~$REAL_USER")
DOTFILES_DIR="$REAL_HOME/dotfiles" # Assuming this is the clone location

# --- OS Detection ---
OS_FAMILY=""
if [[ "$(uname)" == "Darwin" ]]; then
    OS_FAMILY="macos"
elif [[ -f /etc/lsb-release || -f /etc/debian_version ]]; then
    OS_FAMILY="ubuntu"
else
    log_error "Unsupported operating system. This script supports macOS and Ubuntu."
fi
log_info "Detected OS Family: $OS_FAMILY"

# --- Dependency Installation Functions ---
install_deps_ubuntu() {
    log_info "Checking Ubuntu dependencies..."
    sudo apt-get update || log_warn "Could not update apt package lists."
    
    local missing_deps=()
    local deps_to_check=(git salt-minion python3 python3-pip)
    for dep in "${deps_to_check[@]}"; do
        if ! dpkg -s "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}..."
        sudo apt-get install -y "${missing_deps[@]}" || log_error "Failed to install dependencies."
    else
        log_success "All essential dependencies are already installed."
    fi
}

install_deps_macos() {
    if ! command -v brew &>/dev/null; then
        log_warn "Homebrew not found. Attempting to install..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || log_error "Failed to install Homebrew."
    else
        log_success "Homebrew is already installed."
    fi

    log_info "Checking Homebrew dependencies..."
    brew update || log_warn "Failed to update Homebrew."

    local missing_deps=()
    local deps_to_check=(git salt python)
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
fi

log_step "Cloning Dotfiles Repository"
if [ ! -d "$DOTFILES_DIR" ]; then
    log_info "Cloning dotfiles repository to ${DOTFILES_DIR}..."
    git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR" || log_error "Failed to clone dotfiles repository."
else
    log_info "Dotfiles repository already exists at ${DOTFILES_DIR}. Skipping clone."
fi

log_step "Preparing Pillar for Salt"
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
TEMP_PILLAR_FILE="${TEMP_PILLAR_DIR}/user_details.sls"

sudo mkdir -p "$TEMP_PILLAR_DIR" || log_error "Failed to create temporary Pillar directory."
sudo chmod 700 "$TEMP_PILLAR_DIR" || log_error "Failed to adjust permissions for temporary directory."

sudo bash -c "cat > $TEMP_PILLAR_FILE <<EOF
user: '$REAL_USER'
home: '$REAL_HOME'
EOF" || log_error "Failed to write temporary Pillar file."

sudo chmod 600 "$TEMP_PILLAR_FILE" || log_error "Failed to adjust permissions for temporary Pillar file."
log_success "Temporary Pillar prepared!"

log_step "Applying Salt States (Main Configuration)"
log_info "Installing Salt dependencies"
sudo pip install contextvars # Ensure contextvars is available for salt-call
log_info "Salt is now configuring your system. This may take a while... 🦥"
sudo salt-call --local --file-root="$DOTFILES_DIR/salt/roots/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply --log-level debug || log_error "Failed to apply Salt states. Check logs above."
log_success "Salt states applied successfully! Your environment is almost ready!"

log_step "Setting Zsh as Default Shell"
if command -v zsh &>/dev/null; then
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
log_success "Cleanup complete!"

echo -e "\n${GREEN}${BOLD}${CHECK_EMOJI} SETUP COMPLETE! ${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------
${RESET}"
log_step "NEXT STEPS: What to do now?"

log_info "1. Open a new terminal (or restart your shell)"
echo -e "${GREEN}   This will load your new Zsh configuration and start installing plugins. This might take a few moments. 🦥${RESET}"

echo -e "\n${GREEN}--------------------------------------------------------------------
${RESET}
