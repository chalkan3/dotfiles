# Zsh Options

# Change directory without `cd`
setopt AUTO_CD

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Error-friendly directory navigation
setopt CDABLE_VARS

# Better globbing
setopt EXTENDED_GLOB

# Don't kill background jobs on exit
setopt NO_HUP

# Don't warn about nonexistent files for glob
setopt NO_NOMATCH

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt BANG_HIST              # Treat ! specially
setopt EXTENDED_HISTORY       # Add timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS       # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # Ignore all duplicates in history
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates
setopt HIST_VERIFY            # Don't execute immediately
setopt SHARE_HISTORY          # Share history between terminals

# Completion options
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Key Binds
bindkey -e # Use emacs keybindings
