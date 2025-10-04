# ======================================================================
# ZSHRC DINÂMICO E PORTÁTIL (Funciona para qualquer $HOME)
# ======================================================================

# FUNÇÃO DE BOAS-VINDAS:
welcome_message() {
  if [[ -o INTERACTIVE ]]; then
    local BLUE=$(printf '\e[34m')
    local RESET=$(printf '\e[0m')
    
    printf "\n%s" "$BLUE"
    
    # Usa o hostname ($(%n)) para tornar a mensagem dinâmica
    printf " > chalkan3 :: %s < \n" "${(%):-%n}"
    
    printf "%s" "$RESET"
    printf "\n%s\n\n" "🦥 ... slow and steady ... 🦥"
  fi
}
welcome_message
unset -f welcome_message

# Load Powerlevel10k instant prompt if available (Usa $HOME)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Define o diretório de instalação do Zinit (Portátil e Padrão)
# Isso resolve para ~/.local/share/zinit/zinit.git
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# ----------------------------------------------------------------------
# ZINIT LOADER: Simplificado para carregar a instalação, sem instalar novamente.
# Se a instalação foi feita corretamente, ele deve ser carregado aqui.
# ----------------------------------------------------------------------

# Tenta carregar Zinit do local padrão (~/.local/share/zinit/zinit.git)
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"

# Verifica se foi instalado via Homebrew (Alternativa)
elif command -v brew &> /dev/null && [ -f "$(brew --prefix)/opt/zinit/zinit.zsh" ]; then
    source "$(brew --prefix)/opt/zinit/zinit.zsh"
    
# Se não for encontrado, instrui o usuário.
else
    echo "FATAL ERROR: Zinit not found. Please run the Zinit manual installation for user $USER."
fi

# ----------------------------------------------------------------------
# END ZINIT LOADER
# ----------------------------------------------------------------------


# LOAD ZINIT PLUGINS (DEVE VIR *DEPOIS* que o comando Zinit for definido)
# Usando $HOME para portabilidade
source "${HOME}/.zsh/plugins.zsh"


# LOAD POWERLEVEL10K CONFIG (Usando $HOME)
[[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"


# LOAD OTHER CONFIGURATION FILES (Usando $HOME)
source "${HOME}/.zsh/env.zsh"
source "${HOME}/.zsh/aliases.zsh"
source "${HOME}/.zsh/functions.zsh"

# LOAD FZF CONFIG (Usando $HOME)
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
