# ═══════════════════════════════════════════════════════════════════════
# 🛠️  Custom Functions
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# 📚 Help & Documentation
# ───────────────────────────────────────────────────────────────────────

# Show keyboard shortcuts guide
keys() {
    local keybindings_file

    # Try to find KEYBINDINGS.md in common locations
    if [[ -f "$HOME/KEYBINDINGS.md" ]]; then
        keybindings_file="$HOME/KEYBINDINGS.md"
    elif [[ -f "$HOME/.config/KEYBINDINGS.md" ]]; then
        keybindings_file="$HOME/.config/KEYBINDINGS.md"
    elif [[ -f "/tmp/dotfiles_clone/KEYBINDINGS.md" ]]; then
        keybindings_file="/tmp/dotfiles_clone/KEYBINDINGS.md"
    else
        echo "❌ KEYBINDINGS.md não encontrado!"
        echo ""
        echo "Para criar o arquivo, copie do repositório:"
        echo "  cp /tmp/dotfiles_clone/KEYBINDINGS.md ~/KEYBINDINGS.md"
        return 1
    fi

    # Show with bat if available (syntax highlighting), otherwise use less
    if command -v bat &> /dev/null; then
        bat --style=full --paging=always "$keybindings_file"
    elif command -v batcat &> /dev/null; then
        batcat --style=full --paging=always "$keybindings_file"
    else
        less "$keybindings_file"
    fi
}

# Show quick cheat sheet of most used shortcuts
keycheat() {
    printf "\n\e[1;34m⌨️  Atalhos mais Usados do Terminal\e[0m\n\n"

    printf "\e[1;36m🏃 Navegação entre Palavras\e[0m\n"
    printf "  \e[33mOption + →/←\e[0m     Pular palavras\n"
    printf "  \e[33mCtrl + a/e\e[0m       Início/Fim da linha\n\n"

    printf "\e[1;36m✂️  Deletar\e[0m\n"
    printf "  \e[33mCtrl + w\e[0m         Deleta palavra anterior\n"
    printf "  \e[33mOption + d\e[0m       Deleta próxima palavra\n"
    printf "  \e[33mCtrl + k\e[0m         Deleta até fim da linha\n"
    printf "  \e[33mCtrl + u\e[0m         Deleta até início da linha\n\n"

    printf "\e[1;36m📋 Clipboard\e[0m\n"
    printf "  \e[33mCtrl + w\e[0m         Deleta e guarda\n"
    printf "  \e[33mCtrl + y\e[0m         Cola de volta\n\n"

    printf "\e[1;36m🔍 Busca\e[0m\n"
    printf "  \e[33mCtrl + r\e[0m         Busca no histórico (fzf)\n\n"

    printf "\e[1;36m🔙 Outros\e[0m\n"
    printf "  \e[33mCtrl + _\e[0m         Desfaz última edição\n"
    printf "  \e[33mCtrl + x, Ctrl + e\e[0m Abre no editor\n\n"

    printf "\e[90mPara ver guia completo: \e[32mkeys\e[0m\n\n"
}

# ───────────────────────────────────────────────────────────────────────
# 📂 Directory Operations
# ───────────────────────────────────────────────────────────────────────

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go up N directories (usage: up 3)
up() {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# ───────────────────────────────────────────────────────────────────────
# 🔍 Search & Find
# ───────────────────────────────────────────────────────────────────────

# Find file by name (usage: ff filename)
ff() {
  fd -H -I "$1"
}

# Find in files (usage: fif "search term")
fif() {
  if [ $# -eq 0 ]; then
    echo "Usage: fif <search term>"
    return 1
  fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Search and open with nvim using fzf
flvim() {
  if [ -z "$1" ]; then
    echo "Usage: flvim <search_term>"
    return 1
  fi

  local selected
  selected=$(
    rg --line-number --no-heading --color=always "$1" |
    fzf --ansi \
        --delimiter ':' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window=right:60%:wrap
  )

  if [[ -n "$selected" ]]; then
    local file_path=$(echo "$selected" | cut -d: -f1)
    local line_number=$(echo "$selected" | cut -d: -f2)

    nvim +$line_number "$file_path"
  fi
}

# Interactive cd with fzf
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=1 --color=always {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# ───────────────────────────────────────────────────────────────────────
# 🗜️  Archive Operations
# ───────────────────────────────────────────────────────────────────────

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

# Create an archive (usage: compress <file> <type>)
compress() {
  if [ $# -lt 2 ]; then
    echo "Usage: compress <file/directory> <type>"
    echo "Types: tar.gz, tar.bz2, zip"
    return 1
  fi

  case "$2" in
    tar.gz)  tar czf "$1.tar.gz" "$1" ;;
    tar.bz2) tar cjf "$1.tar.bz2" "$1" ;;
    zip)     zip -r "$1.zip" "$1" ;;
    *)       echo "Unknown archive type: $2" ;;
  esac
}

# ───────────────────────────────────────────────────────────────────────
# 🌐 Git Functions
# ───────────────────────────────────────────────────────────────────────

# Clone and cd into directory
gcl() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Git commit with auto-generated message based on changes
gac() {
  git add -A
  if [ -z "$1" ]; then
    git commit -v
  else
    git commit -m "$1"
  fi
}

# Delete merged branches (keeps main/master/develop)
git-clean-branches() {
  git branch --merged | egrep -v "(^\*|main|master|develop)" | xargs git branch -d
}

# Git undo - goes back N commits (usage: gundo 3)
git-undo() {
  local commits=${1:-1}
  git reset --soft HEAD~$commits
}

# Show git branch with fzf
git-branch-fzf() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# ───────────────────────────────────────────────────────────────────────
# 🐳 Docker Functions
# ───────────────────────────────────────────────────────────────────────

# Docker cleanup - remove stopped containers, unused images, networks
docker-cleanup() {
  echo "🧹 Cleaning Docker..."
  docker container prune -f
  docker image prune -f
  docker network prune -f
  docker volume prune -f
  echo "✅ Docker cleanup complete!"
}

# Docker shell into container
dsh() {
  if [ -z "$1" ]; then
    echo "Usage: dsh <container_name_or_id>"
    return 1
  fi
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Docker stats with formatting
dstats() {
  docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# ───────────────────────────────────────────────────────────────────────
# 🌐 Network Functions
# ───────────────────────────────────────────────────────────────────────

# Kill process running on port
port-kill() {
  if [ -z "$1" ]; then
    echo "Usage: port-kill <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9
  echo "✅ Killed process on port $1"
}

# Show what's using a port
port-check() {
  if [ -z "$1" ]; then
    echo "Usage: port-check <port>"
    return 1
  fi
  lsof -i :$1
}

# Get external IP
myip() {
  echo "Local IP:  $(ipconfig getifaddr en0)"
  echo "Public IP: $(curl -s ifconfig.me)"
}

# ───────────────────────────────────────────────────────────────────────
# 📊 System Info
# ───────────────────────────────────────────────────────────────────────

# System information
sysinfo() {
  echo "═══════════════════════════════════════════════"
  echo "🖥️  System Information"
  echo "═══════════════════════════════════════════════"
  echo "Hostname:    $(hostname)"
  echo "macOS:       $(sw_vers -productVersion)"
  echo "Kernel:      $(uname -r)"
  echo "Uptime:      $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  echo "Shell:       $SHELL"
  echo "Terminal:    $TERM"
  echo "CPU:         $(sysctl -n machdep.cpu.brand_string)"
  echo "Memory:      $(sysctl hw.memsize | awk '{print $2/1024/1024/1024 " GB"}')"
  echo "Disk Usage:  $(df -h / | awk 'NR==2{print $3"/"$2" ("$5" used)"}')"
  echo "═══════════════════════════════════════════════"
}

# ───────────────────────────────────────────────────────────────────────
# 🔧 Utilities
# ───────────────────────────────────────────────────────────────────────

# Generate QR code in terminal
qr() {
  if [ -z "$1" ]; then
    echo "Usage: qr <text or url>"
    return 1
  fi
  curl qrenco.de/"$1"
}

# URL shortener
shorten() {
  if [ -z "$1" ]; then
    echo "Usage: shorten <url>"
    return 1
  fi
  curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Generate random password
genpass() {
  local length=${1:-20}
  openssl rand -base64 48 | cut -c1-$length
}

# Create backup of file
backup() {
  if [ -z "$1" ]; then
    echo "Usage: backup <file>"
    return 1
  fi
  cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
  echo "✅ Backup created: $1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Show directory size
dirsize() {
  du -sh ${1:-.} 2>/dev/null | awk '{print $1}'
}

# Calculator (usage: calc "2+2")
calc() {
  echo "$*" | bc -l
}

# ───────────────────────────────────────────────────────────────────────
# 📡 SSH Functions
# ───────────────────────────────────────────────────────────────────────

# Connect to specific hosts
ssh-lady() {
  ssh chalkan3@192.168.1.16
}

ssh-keite() {
  ssh chalkan3@192.168.1.17
}

ssh-do-vault-01() {
  ssh chalkan3@159.65.189.46 -i ~/.ssh/id_ed25519
}

ssh-do-workload-01() {
  ssh chalkan3@138.197.88.209 -i ~/.ssh/id_ed25519
}

# Execute commands on remote host
ssh-exec() {
  CMD=$1
  ssh chalkan3@192.168.1.16 "${CMD}"
}

# Copy SSH key to remote server
ssh-copy-key() {
  if [ -z "$1" ]; then
    echo "Usage: ssh-copy-key <user@host>"
    return 1
  fi
  cat ~/.ssh/id_ed25519.pub | ssh "$1" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
}

# ───────────────────────────────────────────────────────────────────────
# 🦥 Raspberry Pi NTFY Listener Manager
# ───────────────────────────────────────────────────────────────────────

SCRIPT_PATH="$HOME/.local/bin/raspberry-listner.rb"
PROCESS_NAME="raspberry-listner.rb"

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

rpi_listener_stop() {
  if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "🛑 Stopping Raspberry Pi Listener..."
    pkill -f "$PROCESS_NAME"
    echo "✅ Raspberry Pi Listener stopped."
  else
    echo "✅ Raspberry Pi Listener was not running."
  fi
}

rpi_listener_status() {
  if pgrep -af "$PROCESS_NAME" > /dev/null; then
    echo "✅ Raspberry Pi Listener is running."
    pgrep -af "$PROCESS_NAME"
  else
    echo "❌ Raspberry Pi Listener is not running."
  fi
}

# ───────────────────────────────────────────────────────────────────────
# 📚 Help & Documentation
# ───────────────────────────────────────────────────────────────────────

# Display available custom aliases and functions
zsh-help() {
  echo "💡 \e[1mAvailable Custom Commands\e[0m
"

  echo "\e[1;34mALIASES\e[0m"
  echo "--------------------------"
  grep '^alias' ~/.zsh/aliases.zsh | cut -d'=' -f1 | sed 's/alias //' | sort | awk '{printf "  - %s\n", $1}'
  echo ""

  echo "\e[1;32mFUNCTIONS\e[0m"
  echo "--------------------------"
  grep -o '^[a-zA-Z0-9_-]\+\s*()' ~/.zsh/functions.zsh | sed 's/()//' | sort | awk '{printf "  - %s\n", $1}'
  echo ""

  echo "\e[1;33mUSAGE\e[0m"
  echo "--------------------------"
  echo "  - explore     : Interactive command explorer"
  echo "  - show <cmd>  : Show what a command does"
  echo ""
}

# Show what a command does (alias or function)
show() {
  if [ -z "$1" ]; then
    echo "Usage: show <command_name>"
    echo "Example: show gp"
    return 1
  fi

  local cmd="$1"
  local found=0

  # Check if it's an alias
  if alias "$cmd" &>/dev/null; then
    echo "\e[1;34m📌 ALIAS:\e[0m $cmd"
    echo "\e[1;37mDefinition:\e[0m"
    alias "$cmd" | sed 's/^[^=]*=/  /'
    found=1
  fi

  # Check if it's a function
  if type "$cmd" 2>/dev/null | grep -q "function"; then
    echo "\e[1;32m🔧 FUNCTION:\e[0m $cmd"
    echo "\e[1;37mDefinition:\e[0m"
    type "$cmd" | sed '1d' | sed 's/^/  /'
    found=1
  fi

  # Check if it's a binary/executable
  if command -v "$cmd" &>/dev/null && [ $found -eq 0 ]; then
    echo "\e[1;35m⚙️  EXECUTABLE:\e[0m $cmd"
    echo "\e[1;37mLocation:\e[0m $(which "$cmd")"

    # Try to show version or help
    if "$cmd" --version &>/dev/null; then
      echo "\e[1;37mVersion:\e[0m"
      "$cmd" --version 2>&1 | head -1 | sed 's/^/  /'
    fi
    found=1
  fi

  if [ $found -eq 0 ]; then
    echo "\e[1;31m❌ Command not found:\e[0m $cmd"
    return 1
  fi
}

# Interactive command explorer with fzf
explore() {
  # Create temporary file with all commands and descriptions
  local tmpfile=$(mktemp)

  echo "# ════════════════════════════════════════════════════════════" > "$tmpfile"
  echo "# 🎯 NAVIGATION & FILES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "cd (z)          │ Smart cd with zoxide (learns your habits)" >> "$tmpfile"
  echo "..              │ Go up one directory" >> "$tmpfile"
  echo "...             │ Go up two directories" >> "$tmpfile"
  echo "-               │ Go to previous directory" >> "$tmpfile"
  echo "ls              │ List files with icons (eza)" >> "$tmpfile"
  echo "ll              │ List files with git status" >> "$tmpfile"
  echo "lt              │ Tree view of files" >> "$tmpfile"
  echo "fcd             │ Interactive cd with fzf preview" >> "$tmpfile"
  echo "mkcd            │ Create directory and cd into it" >> "$tmpfile"
  echo "up <n>          │ Go up N directories (e.g., up 3)" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🔍 SEARCH & FIND" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "ff <name>       │ Find file by name" >> "$tmpfile"
  echo "fif <text>      │ Find text in files (interactive)" >> "$tmpfile"
  echo "flvim <text>    │ Search and open in nvim" >> "$tmpfile"
  echo "grep            │ Search with ripgrep (rg)" >> "$tmpfile"
  echo "find            │ Find files with fd" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🌐 GIT COMMANDS" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "gs              │ Git status (short format)" >> "$tmpfile"
  echo "ga <file>       │ Git add file" >> "$tmpfile"
  echo "gaa             │ Git add all" >> "$tmpfile"
  echo "gc <msg>        │ Git commit with message" >> "$tmpfile"
  echo "gp              │ Git push" >> "$tmpfile"
  echo "gpull           │ Git pull with rebase" >> "$tmpfile"
  echo "gco <branch>    │ Git checkout branch" >> "$tmpfile"
  echo "gcb <branch>    │ Create and checkout new branch" >> "$tmpfile"
  echo "gl              │ Git log (one line, graph)" >> "$tmpfile"
  echo "gd              │ Git diff" >> "$tmpfile"
  echo "gsta            │ Git stash" >> "$tmpfile"
  echo "gstap           │ Git stash pop" >> "$tmpfile"
  echo "gundo           │ Undo last commit (keep changes)" >> "$tmpfile"
  echo "gwip            │ Quick WIP commit" >> "$tmpfile"
  echo "gcl <url>       │ Clone repo and cd into it" >> "$tmpfile"
  echo "git-clean-branches │ Delete merged branches" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🐳 DOCKER" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "dps             │ Docker ps (list containers)" >> "$tmpfile"
  echo "dex <name>      │ Docker exec into container" >> "$tmpfile"
  echo "dsh <name>      │ Shell into container" >> "$tmpfile"
  echo "dlog <name>     │ Follow container logs" >> "$tmpfile"
  echo "dprune          │ Clean all Docker resources" >> "$tmpfile"
  echo "docker-cleanup  │ Full Docker cleanup with messages" >> "$tmpfile"
  echo "dcu             │ Docker compose up -d" >> "$tmpfile"
  echo "dcd             │ Docker compose down" >> "$tmpfile"
  echo "dcl             │ Docker compose logs -f" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# ☸️  KUBERNETES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "k               │ kubectl" >> "$tmpfile"
  echo "kgp             │ Get pods" >> "$tmpfile"
  echo "kgs             │ Get services" >> "$tmpfile"
  echo "kex <pod>       │ Exec into pod" >> "$tmpfile"
  echo "kl <pod>        │ Follow pod logs" >> "$tmpfile"
  echo "kctx <context>  │ Switch context" >> "$tmpfile"
  echo "kns <namespace> │ Switch namespace" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🌐 NETWORK & SYSTEM" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "port-kill <port> │ Kill process on port" >> "$tmpfile"
  echo "port-check <port> │ Show what's using port" >> "$tmpfile"
  echo "ports           │ Show all listening ports" >> "$tmpfile"
  echo "myip            │ Show local and public IP" >> "$tmpfile"
  echo "ip              │ Local IP address" >> "$tmpfile"
  echo "publicip        │ Public IP address" >> "$tmpfile"
  echo "speedtest       │ Run internet speed test" >> "$tmpfile"
  echo "sysinfo         │ Complete system information" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🐍 PYTHON" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "py              │ Python3" >> "$tmpfile"
  echo "venv            │ Create and activate venv" >> "$tmpfile"
  echo "venv-activate   │ Activate existing venv" >> "$tmpfile"
  echo "pipup           │ Upgrade pip, setuptools, wheel" >> "$tmpfile"
  echo "pipreq          │ Generate requirements.txt" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🔧 UTILITIES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "cat             │ Show file with syntax (bat)" >> "$tmpfile"
  echo "extract <file>  │ Extract any archive format" >> "$tmpfile"
  echo "compress <file> <type> │ Create archive (tar.gz, zip)" >> "$tmpfile"
  echo "backup <file>   │ Create timestamped backup" >> "$tmpfile"
  echo "genpass [len]   │ Generate secure password" >> "$tmpfile"
  echo "qr <text>       │ Generate QR code in terminal" >> "$tmpfile"
  echo "weather         │ Show weather forecast" >> "$tmpfile"
  echo "json            │ Format JSON from stdin" >> "$tmpfile"
  echo "calc <expr>     │ Calculator (e.g., calc 2+2)" >> "$tmpfile"
  echo "dirsize [dir]   │ Show directory size" >> "$tmpfile"
  echo "please          │ Rerun last command with sudo" >> "$tmpfile"
  echo "reload          │ Reload zsh configuration" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🪟 ZELLIJ (Terminal Multiplexer)" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "zj              │ Start Zellij" >> "$tmpfile"
  echo "zjs [name]      │ Smart session (create/attach)" >> "$tmpfile"
  echo "zjp [layout]    │ Project session (named by dir)" >> "$tmpfile"
  echo "zjls            │ List sessions (pretty)" >> "$tmpfile"
  echo "zjrm            │ Delete sessions (interactive)" >> "$tmpfile"
  echo "zjdev           │ Start with dev layout" >> "$tmpfile"
  echo "zjfs            │ Start with fullstack layout" >> "$tmpfile"
  echo "zjops           │ Start with ops layout" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# ⚙️  CONFIGURATION" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "edit-zshrc      │ Edit .zshrc" >> "$tmpfile"
  echo "edit-alias      │ Edit aliases" >> "$tmpfile"
  echo "edit-functions  │ Edit functions" >> "$tmpfile"
  echo "edit-plugins    │ Edit plugins" >> "$tmpfile"
  echo "edit-options    │ Edit zsh options" >> "$tmpfile"
  echo "zsh-help        │ List all commands" >> "$tmpfile"
  echo "show <cmd>      │ Show what command does" >> "$tmpfile"
  echo "explore         │ This interactive explorer" >> "$tmpfile"

  # Use fzf to select and show command
  local selection
  selection=$(cat "$tmpfile" | \
    grep -v '^#' | \
    grep -v '^$' | \
    fzf --ansi \
        --header="📚 Command Explorer - Press ENTER to see details, ESC to quit" \
        --header-first \
        --prompt="Search: " \
        --preview='echo {} | cut -d" " -f1 | xargs -I CMD zsh -ic "show CMD"' \
        --preview-window=right:60%:wrap \
        --border=rounded \
        --height=90%)

  rm "$tmpfile"

  if [[ -n "$selection" ]]; then
    local cmd=$(echo "$selection" | awk '{print $1}')
    echo "\n\e[1;36m═══════════════════════════════════════════════\e[0m"
    echo "\e[1;36m📖 Detailed view of:\e[0m $cmd"
    echo "\e[1;36m═══════════════════════════════════════════════\e[0m\n"
    show "$cmd"

    # Ask if user wants to try it
    echo "\n\e[1;33m💡 Try it now? (y/N):\e[0m \c"
    read -q response
    if [[ "$response" == "y" ]]; then
      echo "\n\e[1;32m▶ Running:\e[0m $cmd"
      print -z "$cmd "  # Pre-fill command line
    fi
  fi
}

# Show function definition (kept for backwards compatibility)
show-func() {
  show "$1"
}

# ───────────────────────────────────────────────────────────────────────
# 🪟 Zellij Session Management
# ───────────────────────────────────────────────────────────────────────

# Smart Zellij session creator/attacher
zjs() {
  if [ -z "$1" ]; then
    # No argument - show sessions and let user pick
    local sessions=$(zellij list-sessions 2>/dev/null | grep -v "^$")

    if [ -z "$sessions" ]; then
      echo "No active sessions. Creating new session..."
      zellij
    else
      # Use fzf to select session
      local selected=$(echo "$sessions" | fzf --header="Select a session to attach (Ctrl-C to create new)")

      if [ -n "$selected" ]; then
        local session_name=$(echo "$selected" | awk '{print $1}')
        zellij attach "$session_name"
      else
        # User cancelled - create new session
        zellij
      fi
    fi
  else
    # Argument provided - use it as session name
    local session_name="$1"
    local layout="$2"

    # Check if session exists
    if zellij list-sessions 2>/dev/null | grep -q "^$session_name"; then
      echo "📎 Attaching to existing session: $session_name"
      zellij attach "$session_name"
    else
      echo "🆕 Creating new session: $session_name"
      if [ -n "$layout" ]; then
        zellij --session "$session_name" --layout "$layout"
      else
        zellij --session "$session_name"
      fi
    fi
  fi
}

# Quick project session - creates/attaches to session named after current directory
zjp() {
  local project_name=$(basename "$PWD")
  local layout="${1:-dev}"

  echo "🚀 Starting Zellij session for project: $project_name"
  zjs "$project_name" "$layout"
}

# Zellij session fuzzy finder - delete session
zjrm() {
  local sessions=$(zellij list-sessions 2>/dev/null | grep -v "^$")

  if [ -z "$sessions" ]; then
    echo "No active sessions to delete."
    return
  fi

  local selected=$(echo "$sessions" | fzf --multi --header="Select sessions to delete (Tab to select multiple)")

  if [ -n "$selected" ]; then
    echo "$selected" | while read session; do
      local session_name=$(echo "$session" | awk '{print $1}')
      echo "🗑️  Deleting session: $session_name"
      zellij kill-session "$session_name"
    done
  fi
}

# List Zellij sessions with details
zjls() {
  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"
  echo "\e[1;36m📋 Active Zellij Sessions\e[0m"
  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"

  local sessions=$(zellij list-sessions 2>/dev/null)

  if [ -z "$sessions" ]; then
    echo "\e[1;33m⚠️  No active sessions\e[0m"
  else
    echo "$sessions" | while read -r line; do
      if [ -n "$line" ]; then
        echo "\e[1;32m  ▪\e[0m $line"
      fi
    done
  fi

  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"
  echo "\e[1;90mTip: Use 'zjs <name>' to create/attach to a session\e[0m"
}

# Async callback (for zsh-async)
async-callback() {
    local job_name=$1
    local return_code=$2
    local output=$3
    echo "\n[Callback] The '$job_name' finished with code ($return_code) output -> $output"
    zle reset-prompt
}
