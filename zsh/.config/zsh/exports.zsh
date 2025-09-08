echo "DEBUG: Sourcing exports.zsh"
# ~/.config/zsh/exports.zsh
# All environment variables and PATH modifications.

# Default Editor
export EDITOR='lvim'




# --- FZF Rich Preview Configuration ---
# This makes FZF use bat and lsd for amazing previews.
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=border-bottom'

# Use fd (if available) for faster file searching
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Preview options for file and directory browsing
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} || lsd --tree --depth=3 --color=always {} || echo {}'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --depth=3 --color=always {} | head -200'"

export NVIM_APPNAME="lvim"