# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc
# The Power User's Edition: Focused on interactivity and workflow automation.

# ------------------------------------------------------------------------------
# 1. LOAD ZINIT (PLUGIN MANAGER)
# ------------------------------------------------------------------------------
# The following line will be added by the Zinit installer.
# For now, we source it assuming it's at the default location.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"
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

zinit ice wait"0" lucid \
  atclone'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash' \ 
  atload'export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"'
zinit snippet OMZ::lib/functions.zsh 

zinit ice from"gh-r" as"program" lucid \
    atload"source $NVM_DIR/nvm.sh --no-use" \
    if"[[ ! -f $NVM_DIR/nvm.sh ]]"
zinit snippet $NVM_DIR/nvm.sh

zinit ice as"completion" lucid atclone"glab completion -s zsh > _glab" \
    atpull'%atclone' src"_glab"
zinit light glab/cli

# ------------------------------------------------------------------------------
# 4. LOAD PERSONAL CONFIGURATION FILES
# ------------------------------------------------------------------------------
ZSH_CONFIG_DIR="$HOME/.config/zsh"
if [[ -d "$ZSH_CONFIG_DIR" ]]; then
  zinit snippet "$ZSH_CONFIG_DIR/exports.zsh"
  zinit snippet "$ZSH_CONFIG_DIR/options.zsh"
  zinit snippet "$ZSH_CONFIG_DIR/aliases.zsh"
  zinit snippet "$ZSH_CONFIG_DIR/functions.zsh"
  zinit snippet "$ZSH_CONFIG_DIR/keybindings.zsh"

  source "$ZSH_CONFIG_DIR/exports.zsh"
  source "$ZSH_CONFIG_DIR/options.zsh"
  source "$ZSH_CONFIG_DIR/aliases.zsh"
  source "$ZSH_CONFIG_DIR/functions.zsh"
  source "$ZSH_CONFIG_DIR/keybindings.zsh"


  # Load WSL-specific settings only if running in WSL
  if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
    zinit snippet "$ZSH_CONFIG_DIR/wsl.zsh"
  fi
fi

# ------------------------------------------------------------------------------
# 5. FINAL SETUP (POST-LOAD)
# ------------------------------------------------------------------------------
# Required for the Powerlevel10k theme to initialize
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
