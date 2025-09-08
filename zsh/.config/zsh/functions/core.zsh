p() {
  ~/.config/zellij/scripts/ruby/bin/p
}

# preexec() {
#   ~/.config/zellij/scripts/ruby/bin/set-title
# 
# }
# 
# precmd() {
#   ~/.config/zellij/scripts/ruby/bin/set-title
# }



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
