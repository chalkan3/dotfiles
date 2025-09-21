# LunarVim Integration Functions

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
