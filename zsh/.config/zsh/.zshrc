# ~/.config/zsh/.zshrc
# Main Zsh configuration file.

# --- Plugin Manager (Zinit) ---
# Auto-installs zinit if it's not already there.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins ---
# Load essential plugins.
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

# Turbo mode (for faster Zsh startup)
zinit ice wait"0" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice as"completion"
zinit light zsh-users/zsh-completions

# --- Additional Professional Tools ---

# zoxide: A smarter cd command
# It learns your most used directories. Use `z <dirname>` to jump.
zinit ice from"gh-r" as"program"
zinit light ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# starship: A modern, fast, and informative prompt
# Shows git status, programming language versions, etc.
zinit ice from"gh-r" as"program"
zinit light starship/starship
eval "$(starship init zsh)"

# direnv: Per-project environment variables
# Loads .envrc files automatically when you cd into a directory.
zinit light direnv/direnv
eval "$(direnv hook zsh)"

# --- Git & Search Tools ---

# ripgrep: A better grep
zinit ice from"gh-r" as"program"
zinit light BurntSushi/ripgrep

# lazygit: A terminal UI for git
zinit ice from"gh-r" as"program"
zinit light jesseduffield/lazygit

# delta: A better git diff viewer
zinit ice from"gh-r" as"program"
zinit light dandavison/delta

# atuin: A better shell history
zinit ice from"gh-r" as"program"
zinit light atuinsh/atuin
eval "$(atuin init zsh)"

# --- Load Configuration Files ---
# Source personal configuration files in order.
ZSH_CONFIG_DIR="${HOME}/.config/zsh"

# Load files if they exist
for file in "$ZSH_CONFIG_DIR"/exports.zsh \
            "$ZSH_CONFIG_DIR"/options.zsh \
            "$ZSH_CONFIG_DIR"/aliases.zsh \
            "$ZSH_CONFIG_DIR"/functions.zsh \
            "$ZSH_CONFIG_DIR"/keybindings.zsh; do
  [ -f "$file" ] && source "$file"
done

# Load WSL-specific settings only if in WSL
if grep -q -i "microsoft" /proc/version &> /dev/null; then
  [ -f "$ZSH_CONFIG_DIR/wsl.zsh" ] && source "$ZSH_CONFIG_DIR/wsl.zsh"
fi

# --- Final Touches ---
# Initialize completions
autoload -U compinit && compinit
