# ~/.config/zsh/options.zsh
# Zsh options for a better user experience.

# --- Navigation & Interaction ---
setopt AUTO_CD              # If a command is a directory, cd into it
setopt CORRECT              # Auto correct typos in commands
setopt NOTIFY               # Report status of background jobs immediately
setopt PUSHD_IGNORE_DUPS    # Don't push multiple copies of same dir onto stack

# --- History Configuration ---
HISTFILE=~/.zsh_history    # Where to save history
HISTSIZE=10000             # How many lines of history to keep in memory
SAVEHIST=10000             # How many lines to save to the history file

setopt APPEND_HISTORY      # Append to history, don't overwrite
setopt EXTENDED_HISTORY    # Save timestamp and duration of commands
setopt INC_APPEND_HISTORY  # Save history entry as soon as command is finished
setopt SHARE_HISTORY       # Share history instantly among all open shells

setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when trimming history
setopt HIST_IGNORE_DUPS       # Don't save a command if it's the same as the previous one
setopt HIST_IGNORE_ALL_DUPS   # If you type a command again, remove the old entry
setopt HIST_FIND_NO_DUPS      # When searching, don't show duplicates
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates in the history file

# Don't save certain common commands to history
export HISTORY_IGNORE='ls:cd:cd -:pwd:exit:date:* --help'
