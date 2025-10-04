# ======================================================================
# 1. ZINIT INSTALLATION & LOADER (Com Bloco de Recarga Obrigatório)
# ======================================================================

# Define o caminho padrão e dinâmico (resolve para ~/.local/share/zinit)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"

# Bloco de instalação Padrão do Zinit (Só roda se a pasta não existir)
if [ ! -d "${ZINIT_HOME}/zinit.git" ]; then
    echo "--- Zinit não encontrado. Iniciando a instalação agora... ---"
    
    # Cria o diretório se não existir
    mkdir -p "$(dirname "${ZINIT_HOME}/zinit.git")"
    
    # Executa a instalação
    if bash -c "$(curl -fsSL https://git.io/zinit-install)"; then
        echo "✅ Zinit instalado com sucesso!"
        echo ">>>>> ⚠️ POR FAVOR, RECARREGUE SUA SHELL (execute 'exec zsh', 'exit' ou feche a janela). ⚠️ <<<<<"
        # FORÇA A SAÍDA para que a shell reinicie e carregue a função 'zinit' corretamente
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

# LOAD ZINIT PLUGINS (O comando 'zinit' já está definido no passo 1)
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
