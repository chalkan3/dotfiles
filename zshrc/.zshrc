welcome_message() {
  if [[ -o INTERACTIVE ]]; then
    local BLUE=$(printf '\e[34m')
    local RESET=$(printf '\e[0m')
    
    printf "\n%s" "$BLUE"
    
    # Simple one-line message
    printf " > chalkan3 :: Home < \n"
    
    printf "%s" "$RESET"
    printf "\n%s\n\n" "🦥 ... slow and steady ... 🦥"
  fi
}

welcome_message

unset -f welcome_message

# Load Powerlevel10k instant prompt if available (must be near the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Define the base directory for Zinit (Portable)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"

# ----------------------------------------------------------------------
# ZINIT LOADER: Ensures Zinit is defined before any plugins are loaded.
# ----------------------------------------------------------------------

# 1. Try to load Zinit from the standard install location
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"

# 2. Check if Zinit was installed via Homebrew
elif command -v brew &> /dev/null && [ -f "$(brew --prefix)/opt/zinit/zinit.zsh" ]; then
    source "$(brew --prefix)/opt/zinit/zinit.zsh"

# 3. If Zinit is not found, install it.
else
    echo "--- Zinit not found. Installing Zinit... ---"
    
    # Create the target directory if it doesn't exist
    mkdir -p "$(dirname "${ZINIT_HOME}")"
    
    # Zinit official installation command
    if ! bash -c "$(curl -fsSL https://git.io/zinit-install)"; then
        echo "ERROR: Failed to install Zinit. Check your connection or permissions."
    else
        echo "Zinit installed successfully. Please close and reopen your shell."
        # Zinit will be sourced (loaded) successfully on the NEXT shell launch.
    fi
fi

# ----------------------------------------------------------------------
# END ZINIT LOADER
# ----------------------------------------------------------------------


# LOAD ZINIT PLUGINS (MUST BE SOURCED *AFTER* ZINIT ITSELF IS LOADED)
# Using $HOME for portability
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG
# Using $HOME for portability
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES
# Using $HOME for portability
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG
# Using $HOME for portability
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
