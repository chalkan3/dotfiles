# ======================================================================
# 1. PATH SETUP & ZINIT INSTALLATION/LOADER (Com Link Simbólico)
# ======================================================================

# Adiciona o diretório bin local ao PATH (Crucial para que o link simbólico funcione)
export PATH="$HOME/.local/bin:$PATH"

# Define o caminho padrão e dinâmico
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT_BIN="${HOME}/.local/bin"

# Bloco de instalação Padrão
if [ ! -d "${ZINIT_HOME}/zinit.git" ]; then
    echo "--- Zinit não encontrado. Iniciando a instalação... ---"
    
    # Cria diretórios necessários
    mkdir -p "${ZINIT_HOME}/zinit.git"
    mkdir -p "${ZINIT_BIN}"

    # Executa a instalação
    if bash -c "$(curl -fsSL https://git.io/zinit-install)"; then
        # CRIAÇÃO DO LINK SIMBÓLICO: Faz com que o 'zinit' seja um comando no PATH
        ln -sf "${ZINIT_HOME}/zinit.zsh" "${ZINIT_BIN}/zinit"
        
        echo "✅ Zinit instalado e link simbólico criado."
        echo ">>>>> ⚠️ POR FAVOR, RECARREGUE SUA SHELL (execute 'exec zsh' ou 'exit'). ⚠️ <<<<<"
        # Força o Zsh a recarregar para pegar o novo Zinit.
        return
    else
        echo "❌ ERRO FATAL: Zinit não pôde ser instalado. Verifique rede/permissões."
    fi
fi

# Carrega o Zinit (Este código só roda se a instalação JÁ FOI FEITA)
# O comando 'zinit' é definido aqui.
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"
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
# 3. CARREGAMENTO DA CONFIGURAÇÃO (Plugins e Dotfiles)
# ======================================================================

# LOAD ZINIT PLUGINS (O comando 'zinit' já está definido no passo 1)
# O Zsh agora pode encontrar o 'zinit' antes de ler esta linha.
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
