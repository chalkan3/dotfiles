# ======================================================================
# 1. ZINIT INSTALLATION & LOADER (O bloco que funciona)
# ======================================================================

# Define o caminho padrão e dinâmico (resolve para ~/.local/share/zinit)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"

# Bloco de instalação Padrão do Zinit (Só roda se a pasta não existir)
if [ ! -d "${ZINIT_HOME}/zinit.git" ]; then
    echo "--- Zinit not found. Installing Zinit now... ---"
    
    # Cria o diretório se não existir
    mkdir -p "$(dirname "${ZINIT_HOME}/zinit.git")"
    
    # Executa a instalação
    if bash -c "$(curl -fsSL https://git.io/zinit-install)"; then
        echo "✅ Zinit installed successfully. Please close and reopen your shell."
    else
        echo "❌ FATAL ERROR: Zinit could not be installed. Check network/permissions."
    fi
fi

# Carrega o Zinit (GARANTINDO que a função 'zinit' seja definida)
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"
fi


# ======================================================================
# 2. FUNÇÃO DE BOAS-VINDAS E INSTANT PROMPT (Ajustes de UX)
# ======================================================================

welcome_message() {
  if [[ -o INTERACTIVE ]]; then
    local BLUE=$(printf '\e[34m')
    local RESET=$(printf '\e[0m')
    
    printf "\n%s" "$BLUE"
    
    # Usa o nome da máquina/usuário atual
    printf " > chalkan3 :: %s < \n" "${(%):-%n}"
    
    printf "%s" "$RESET"
    printf "\n%s\n\n" "🦥 ... slow and steady ... 🦥"
  fi
}
welcome_message
unset -f welcome_message

# Load Powerlevel10k instant prompt if available (deve ficar alto no zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ======================================================================
# 3. CARREGAMENTO DA CONFIGURAÇÃO (Onde Zinit é usado)
# ======================================================================

# LOAD ZINIT PLUGINS (A linha mais importante: usa o comando 'zinit' definido acima)
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
