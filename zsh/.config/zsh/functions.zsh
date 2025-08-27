p() {
  ~/.config/zellij/scripts/ruby/bin/p
}

preexec() {
  ~/.config/zellij/scripts/ruby/bin/set-title

}

precmd() {
  ~/.config/zellij/scripts/ruby/bin/set-title
}



# fzf-rg-widget: Interactively search file contents with rg and fzf.
# Triggered by a keybinding (e.g., Ctrl+F).
fzf-rg-widget() {
  # Use rg to find files and pipe to fzf
  local selected
  selected=$( 
    rg --column --line-number --no-heading --color=always --smart-case . | 
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:execute(echo 'lvim {1} +{2}')+abort"
  )

  # If a selection was made, execute it
  if [[ -n "$selected" ]]; then
    eval "$selected"
  fi
  # Redraw the prompt
  zle redisplay
}

# Create a ZLE widget from the function so it can be bound to a key.
zle -N fzf-rg-widget

# --- lvim Integration Functions ---

# Smartly open lvim
# - `v`: opens file explorer in current directory
# - `v <file>`: opens the file
# - `v <dir>`: opens file explorer in that directory
v() {
  if [ -z "$1" ]; then
    lvim .
  else
    # Just pass the argument to lvim. It can handle files and directories.
    lvim "$1"
  fi
}

# Edit configuration files interactively
conf() {
    local selected
    # Create a curated list of common config files and directories
    # Non-existent paths will be ignored by fzf
    local configs=(
        "$HOME/.config/zsh/.zshrc"
        "$HOME/.config/zsh/aliases.zsh"
        "$HOME/.config/zsh/functions.zsh"
        "$HOME/.config/zsh/keybindings.zsh"
        "$HOME/.config/zsh/options.zsh"
        "$HOME/.config/lvim/config.lua"
        "$HOME/.gitconfig"
        "$HOME/.config/starship.toml"
        "$HOME/.config/atuin/config.toml"
    )
    
    # Use fzf to select from the list
    # Use find to get all files in .config as a fallback
    selected=$( (printf "%s\n" "${configs[@]}"; find "$HOME/.config" -type f) | \
                fzf --preview 'bat --color=always --style=numbers {} || lsd --tree {}' )
    
    if [[ -n "$selected" ]]; then
        lvim "$selected"
    fi
}

# Pipe command output directly into an lvim buffer
# Example: `history | lpipe`
lpipe() {
    local temp_file
    temp_file=$(mktemp)
    # Ensure temp file is deleted on exit, interrupt, or termination
    trap 'rm -f "$temp_file"' EXIT INT TERM
    
    # Read from stdin and write to the temp file
    cat > "$temp_file"
    
    # Open the temp file with lvim
    lvim "$temp_file"
}

fvim() {
  if [ -z "$1" ]; then
    echo "Usage: fvim <search_pattern> [path_to_search]"
    return 1
  fi

  local pattern="$1"
  local path="${2:-.}"
  rg --line-number --no-heading --color=always "$pattern" "$path" | \
    fzf --ansi \
        --delimiter ':' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:execute(lvim {1} +{2})"
}

search-edit() {
  fzf --ansi \
      --delimiter ':' \
      --prompt 'Live Ripgrep> ' \
      --header 'Type to search... [Enter] to open, [ESC] to exit' \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind "change:reload(rg --line-number --no-heading --color=always {q} . || true)" \
      --bind "enter:execute(lvim {1} +{2})"
}
