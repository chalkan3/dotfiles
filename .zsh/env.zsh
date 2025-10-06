# ═══════════════════════════════════════════════════════════════════════
# 🌍 Environment Variables & PATH Configuration
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# 🔐 Load sensitive environment variables from ~/.env
# ───────────────────────────────────────────────────────────────────────
# Create ~/.env from ~/.env.example and add your secrets there
if [[ -f "$HOME/.env" ]]; then
    source "$HOME/.env"
fi

# ───────────────────────────────────────────────────────────────────────
# 📁 PATH Configuration
# ───────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# ───────────────────────────────────────────────────────────────────────
# 🐍 Python / Lua
# ───────────────────────────────────────────────────────────────────────
export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"

# ───────────────────────────────────────────────────────────────────────
# 💎 Ruby (rbenv)
# ───────────────────────────────────────────────────────────────────────
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - zsh)"
fi

# ───────────────────────────────────────────────────────────────────────
# 🪨 Lua Rocks
# ───────────────────────────────────────────────────────────────────────
if command -v luarocks &> /dev/null; then
    eval $(luarocks path)
fi

# ───────────────────────────────────────────────────────────────────────
# 🛠️  Editor
# ───────────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'

# ───────────────────────────────────────────────────────────────────────
# 🎨 Colors & Display
# ───────────────────────────────────────────────────────────────────────
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# ───────────────────────────────────────────────────────────────────────
# 📊 FZF Configuration
# ───────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 60%
  --border rounded
  --layout=reverse
  --info inline
  --preview-window=:hidden
  --preview="([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (eza --tree --color=always {} | head -200))"
  --color=fg:#d0d0d0,bg:#1a1a1a,hl:#5f87af
  --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
  --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
  --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
  --bind="ctrl-/:toggle-preview"
  --bind="ctrl-u:preview-half-page-up"
  --bind="ctrl-d:preview-half-page-down"
'

# ───────────────────────────────────────────────────────────────────────
# 📝 Bat (better cat) Configuration
# ───────────────────────────────────────────────────────────────────────
export BAT_THEME="TwoDark"
export BAT_STYLE="numbers,changes,header"

# ───────────────────────────────────────────────────────────────────────
# 🐳 Docker
# ───────────────────────────────────────────────────────────────────────
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# ───────────────────────────────────────────────────────────────────────
# 🧰 Less Configuration
# ───────────────────────────────────────────────────────────────────────
export LESS='-R -F -X -i -M'  # Raw colors, quit if one screen, no init, ignore case, long prompt

# ───────────────────────────────────────────────────────────────────────
# 🌐 Language & Locale
# ───────────────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ───────────────────────────────────────────────────────────────────────
# 🚀 Node Version Manager (if using nvm - lazy load for speed)
# ───────────────────────────────────────────────────────────────────────
# Uncomment if you use nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm without auto-loading node
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ───────────────────────────────────────────────────────────────────────
# 🎯 Homebrew
# ───────────────────────────────────────────────────────────────────────
export HOMEBREW_NO_ANALYTICS=1  # Disable analytics
export HOMEBREW_NO_AUTO_UPDATE=1  # Disable auto-update (update manually with 'brewup')

# ───────────────────────────────────────────────────────────────────────
# 📦 Go
# ───────────────────────────────────────────────────────────────────────
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# ───────────────────────────────────────────────────────────────────────
# 🔍 Ripgrep Configuration
# ───────────────────────────────────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# ───────────────────────────────────────────────────────────────────────
# 🎨 Man Pages with Colors
# ───────────────────────────────────────────────────────────────────────
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
