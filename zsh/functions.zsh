# Custom Functions

# Connect to specific hosts (from original file)
ssh-lady() {
  ssh chalkan3@192.168.1.16
}

ssh-keite() {
  ssh chalkan3@192.168.1.17
}

# A more generic function to execute commands on hosts
# Usage: ssh-exec <host> "command"
# e.g.: ssh-exec chalkan3@192.168.1.16 "ls -la"
ssh-exec() {
  CMD=$1
  ssh chalkan3@192.168.1.16 "${CMD}" 
}

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract common archive formats
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;; 
      *.tar.gz)  tar xzf "$1" ;; 
      *.bz2)     bunzip2 "$1" ;; 
      *.rar)     unrar x "$1" ;; 
      *.gz)      gunzip "$1"  ;; 
      *.tar)     tar xf "$1"  ;; 
      *.tbz2)    tar xjf "$1" ;; 
      *.tgz)     tar xzf "$1" ;; 
      *.zip)     unzip "$1"   ;; 
      *.Z)       uncompress "$1" ;; 
      *.7z)      7z x "$1"    ;; 
      *)         echo "'$1' cannot be extracted via extract()" ;; 
    esac 
  else 
    echo "'$1' is not a valid file" 
  fi 
}

# Display available custom aliases and functions
zsh-help() {
  echo "💡 \e[1mAvailable Custom Commands\e[0m
"

  echo "\e[1;34mALIASES\e[0m"
  echo "--------------------------"
  # Extracts the alias name from the aliases file
  grep '^alias' /Users/chalkan3/.zsh/aliases.zsh | cut -d'=' -f1 | sed 's/alias //' | sort | awk '{printf "  - %s\n", $1}'
  echo ""

  echo "\e[1;32mFUNCTIONS\e[0m"
  echo "--------------------------"
  # Extracts function names from the functions file
  grep -o '^[a-zA-Z0-9_-]\+\s*()' /Users/chalkan3/.zsh/functions.zsh | sed 's/()//' | sort | awk '{printf "  - %s\n", $1}'
  echo ""
}

async-callback() {
    local job_name=$1
    local return_code=$2
    local output=$3
    echo "\n[Callback] The '$job_name' finished with code ($return_code) output -> $output"
    zle reset-prompt # Atualiza o prompt
}

#=======================================================================
# Raspberry Pi (NTFY) Listener Manager
#=======================================================================

# Path to your listener script
SCRIPT_PATH="$HOME/.local/bin/raspberry-listner.rb"

# Process name to search for
PROCESS_NAME="raspberry-listner.rb"

# Function to start the listener
rpi_listener_start() {
  if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "✅ Raspberry Pi Listener is already running."
  else
    echo "🚀 Starting Raspberry Pi Listener in the background..."
    nohup "$SCRIPT_PATH" > "$HOME/.local/bin/raspberry-listner.log" 2>&1 & disown
    sleep 1
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
       echo "✅ Raspberry Pi Listener started successfully."
    else
       echo "❌ Failed to start the Raspberry Pi Listener."
    fi
  fi
}

# Function to stop the listener
rpi_listener_stop() {
  if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "🛑 Stopping Raspberry Pi Listener..."
    pkill -f "$PROCESS_NAME"
    echo "✅ Raspberry Pi Listener stopped."
  else
    echo "✅ Raspberry Pi Listener was not running."
  fi
}

# Function to check the status
rpi_listener_status() {
  if pgrep -af "$PROCESS_NAME" > /dev/null; then
    echo "✅ Raspberry Pi Listener is running."
    pgrep -af "$PROCESS_NAME"
  else
    echo "❌ Raspberry Pi Listener is not running."
  fi
}


