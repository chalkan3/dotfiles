# Custom Aliases

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# LSD
alias ls='lsd'
alias l='ls -l'
alias la='ls -la'
alias lt='ls --tree'

# Git
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gs='git status'
alias gp='git push'
alias gpf='git push --force'
alias gpull='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gl='git log --oneline --decorate --graph'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --graph'


# System
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup'
alias ip="ipconfig getifaddr en0"
alias reload="source ~/.zshrc"
alias cat='bat'

# Salt (from original file)
alias salt='sudo salt'
alias salt-key='sudo salt-key'
alias salt-run='sudo salt-run'
alias sls='sudo salt-key --list-all'

# Pulumi
alias pulumi='sudo pulumi'

#Python 
alias venv-activate='. venv/bin/activate'

#Slothctl
alias slothctl='sudo slothctl'

alias edit-alias='lvim ~/.zsh/aliases.zsh'
alias edit-functions='lvim ~/.zsh/functions.zsh'
alias edit-exports='lvim ~/.zsh/env.zsh'
alias edit-plugins='lvim ~/.zsh/plugins.zsh'
