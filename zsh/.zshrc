# --- PATH Management ---
# Helper function to add a directory to the PATH if it exists and isn't already there.
path_add() {
  if [ -d "$1" ] && [[ ":$PATH:" != ":$1:" ]]; then
    PATH="$1:$PATH"
  fi
}

# Add user bin directories to the front of the PATH
path_add "/usr/bin"
path_add "$HOME/.local/bin"
path_add "$HOME/bin"

# --- Go ---
export GOPATH="$HOME/go"
path_add "/usr/local/bin/go/bin"
path_add "$GOPATH/bin"

# --- Pulumi ---
path_add "$HOME/.pulumi/bin"

# --- Salt ---
export SALT_SALTFILE="/home/${USER}/salt/Saltfile"
path_add "/home/${USER}/salt"

# Finalize the PATH
export PATH

echo "DEBUG: Sourcing ~/.zshrc"
ZSH_CONFIG_DIR="$HOME/.config/zsh"
source "${ZSH_CONFIG_DIR}/exports.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------------------------
# 2. LOAD ZINIT'S ESSENTIAL ANNEXES
# ------------------------------------------------------------------------------
# Loads extensions that give Zinit superpowers (monitoring, etc.)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ------------------------------------------------------------------------------
# 3. LOAD PLUGINS & TOOLS (WITH LAZY LOADING)
# ------------------------------------------------------------------------------

# --- CORE UI & UTILITIES ---
zinit light romkatv/powerlevel10k               # The prompt
zinit light zsh-users/zsh-syntax-highlighting   # Command syntax highlighting
zinit light zsh-users/zsh-autosuggestions     # Command suggestions based on history
zinit ice lucid wait'0'; zinit light zsh-users/zsh-completions # Advanced completions

# --- WORKFLOW & PRODUCTIVITY ---

# FZF (Fuzzy Finder) - Core integrations and keybindings
zinit light-mode for \
    junegunn/fzf-bin \
    junegunn/fzf

# FZF-Tab (Replaces default TAB completion with FZF interface)
zinit ice as"completion"
zinit light Aloxaf/fzf-tab

# Zoxide (Intelligent 'cd' command)
zinit ice as"program" lucid eval"zoxide init zsh"
zinit light ajeetdsouza/zoxide

# Direnv (Per-project environment manager)
zinit ice as"program" lucid eval"direnv hook zsh"
zinit light direnv/direnv

# --- DEVELOPMENT TOOLS (LAZY LOADED) ---
zinit ice on-load"zicompinit; zicdreplay" as"program" lucid for \
    ohmyzsh/ohmyzsh:lib/git.zsh \
    ohmyzsh/ohmyzsh:plugins/git/git.plugin.zsh

# NVM (Node Version Manager)
# NVM is installed by Salt. We just need to source it.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

zinit ice as"completion" lucid atclone="glab completion -s zsh > _glab" atpull="%atclone" src="_glab"
zinit light glab/cli
