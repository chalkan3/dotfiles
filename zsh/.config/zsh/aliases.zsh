# ~/.config/zsh/aliases.zsh
# My aliases for common commands.

# --- General Purpose ---
alias g='npx @google/gemini-cli'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'

# --- Syntax Highlighting & Previews ---
# Use bat instead of cat, aliasing batcat if necessary
if command -v batcat &> /dev/null; then
  alias cat='batcat'
elif command -v bat &> /dev/null; then
  alias cat='bat'
fi

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'

# --- Use lsd instead of ls ---
# Add some more useful flags
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'
alias l.='lsd -d .*'
alias lt='lsd --tree'

# --- Git ---
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit -am'
alias gs='git status'
alias gp='git push'
alias gpull='git pull'
alias gl='git log --oneline --graph --decorate'

# --- Terminal UIs ---
alias lg='lazygit' # A terminal UI for git