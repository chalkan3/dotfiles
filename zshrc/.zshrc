# ═══════════════════════════════════════════════════════════════════════
# 🚀 Zsh Configuration - chalkan3
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# ⚡ Powerlevel10k Instant Prompt (must be at top for performance)
# ───────────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ───────────────────────────────────────────────────────────────────────
# 🔌 Zinit Plugin Manager
# ───────────────────────────────────────────────────────────────────────
# Cross-platform zinit installation
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing zinit (zdharma-continuum/zinit)…%f"
    command mkdir -p "$(dirname ${ZINIT_HOME})" && command chmod g-rwX "$(dirname ${ZINIT_HOME})"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ───────────────────────────────────────────────────────────────────────
# 🔧 Auto-install Missing Tools (once per day check)
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/auto-install.zsh

# ───────────────────────────────────────────────────────────────────────
# ⚙️  Zsh Options & Behavior
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/options.zsh

# ───────────────────────────────────────────────────────────────────────
# 🎨 Plugins (loaded with zinit for performance)
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/plugins.zsh

# ───────────────────────────────────────────────────────────────────────
# 🎭 Powerlevel10k Theme Configuration
# ───────────────────────────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ───────────────────────────────────────────────────────────────────────
# 🌍 Environment Variables & Exports
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/env.zsh

# ───────────────────────────────────────────────────────────────────────
# 🎯 Aliases
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/aliases.zsh

# ───────────────────────────────────────────────────────────────────────
# 🛠️  Functions
# ───────────────────────────────────────────────────────────────────────
source ~/.zsh/functions.zsh

# ───────────────────────────────────────────────────────────────────────
# 🔍 FZF Integration
# ───────────────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ───────────────────────────────────────────────────────────────────────
# 🎯 Completions
# ───────────────────────────────────────────────────────────────────────
# Enable completion system with caching for performance
autoload -Uz compinit

# Cache completion for 20 hours (improves startup time)
if [[ -n ~/.zcompdump(#qN.mh+20) ]]; then
  compinit
else
  compinit -C
fi

# Tool-specific completions
command -v doctl &> /dev/null && source <(doctl completion zsh)
command -v glab &> /dev/null && source <(glab completion -s zsh)

# ───────────────────────────────────────────────────────────────────────
# 🎨 Completion Styling
# ───────────────────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# ───────────────────────────────────────────────────────────────────────
# 🎯 Final PATH (ensure local bin is prioritized)
# ───────────────────────────────────────────────────────────────────────
export PATH=$HOME/.local/bin:$PATH

# ═══════════════════════════════════════════════════════════════════════
# 🎉 End of Configuration
# ═══════════════════════════════════════════════════════════════════════
# Use 'zsh-help' to see available aliases and functions
# Use 'edit-zshrc' to edit this file
# Use 'reload' to reload configuration

# ───────────────────────────────────────────────────────────────────────
# 👋 Welcome Message (after instant prompt to avoid warnings)
# ───────────────────────────────────────────────────────────────────────
if [[ -o INTERACTIVE ]]; then
    printf "\n\e[34m"
    printf "  ██████╗██╗  ██╗ █████╗ ██╗     ██╗  ██╗ █████╗ ███╗   ██╗██████╗ \n"
    printf " ██╔════╝██║  ██║██╔══██╗██║     ██║ ██╔╝██╔══██╗████╗  ██║╚════██╗\n"
    printf " ██║     ███████║███████║██║     █████╔╝ ███████║██╔██╗ ██║ █████╔╝\n"
    printf " ██║     ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══██║██║╚██╗██║ ╚═══██╗\n"
    printf " ╚██████╗██║  ██║██║  ██║███████╗██║  ██╗██║  ██║██║ ╚████║██████╔╝\n"
    printf "  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ \n"
    printf "\e[0m"
    printf "\n              🦥 ... slow and steady ... 🦥\n\n"
fi
