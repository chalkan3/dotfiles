# ~/.config/zsh/keybindings.zsh
# Custom keybindings.

# Bind UP and DOWN arrows to history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind Ctrl+F to the ripgrep-fzf widget for content search.
bindkey '^F' fzf-rg-widget