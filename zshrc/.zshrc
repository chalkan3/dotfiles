# ======================================================================
# ZSHRC: INSTALAÇÃO (Condicional) E CARREGAMENTO DE PLUGINS
# ======================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT_BIN="${HOME}/.local/bin"

# ----------------------------------------------------------------------
# Bloco de Instalação (Só roda se a pasta Zinit não existir)
# ----------------------------------------------------------------------
if [ ! -d "${ZINIT_HOME}/zinit.git" ]; then
    echo "--- Zinit não encontrado. Iniciando a instalação... ---"
    
    mkdir -p "${ZINIT_HOME}/zinit.git"
    mkdir -p "${ZINIT_BIN}"
    
    if bash -c "$(curl -fsSL https://git.io/zinit-install)"; then
        # Cria o link simbólico (útil para o PATH)
        ln -sf "${ZINIT_HOME}/zinit.zsh" "${ZINIT_BIN}/zinit"
        
        echo "✅ Zinit instalado com sucesso!"
        echo ">>>>> ⚠️ POR FAVOR, ENCERRE E REABRA SUA SESSÃO (ou use 'exec zsh') para carregar o Zinit. ⚠️ <<<<<"
        # Saída suave para forçar o reinício da shell
        return 
    fi
fi

# Garante que o link simbólico do Zinit existe após a instalação
if [ -f "${ZINIT_HOME}/zinit.zsh" ] && [ ! -f "${ZINIT_BIN}/zinit" ]; then
    mkdir -p "${ZINIT_BIN}"
    ln -sf "${ZINIT_HOME}/zinit.zsh" "${ZINIT_BIN}/zinit"
fi


# ======================================================================
# 2. FUNÇÃO DE BOAS-VINDAS E INSTANT PROMPT (UX)
# ======================================================================

welcome_message() {
  if [[ -o INTERACTIVE ]]; then
    local BLUE=$(printf '\e[34m')
    local RESET=$(printf '\e[0m')
    
    printf "\n%s" "$BLUE"
    printf " > chalkan3 :: %s < \n" "${(%):-%n}"
    
    printf "%s" "$RESET"
    printf "\n%s\n\n" "🦥 ... slow and steady ... 🦥"
  fi
}
welcome_message
unset -f welcome_message

# Load Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ======================================================================
# 3. ZINIT ANNEXES (Extensões) - Devem carregar antes dos plugins
# ======================================================================

# O comando 'zinit' já está definido pelo .zprofile
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ======================================================================
# 4. CARREGAMENTO DA CONFIGURAÇÃO (Plugins e Dotfiles)
# ======================================================================

# LOAD ZINIT PLUGINS
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
