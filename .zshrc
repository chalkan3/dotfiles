welcome_message() {
  if [[ -o INTERACTIVE ]]; then
    local BLUE=$(printf '\e[34m')
    local RESET=$(printf '\e[0m')
    
    printf "\n%s" "$BLUE"
    
    # Mensagem simples em uma linha
    printf " > chalkan3 :: Home < \n"
    
    printf "%s" "$RESET"
    printf "\n%s\n\n" "🦥 ... slow and steady ... 🦥"
  fi
}

welcome_message

unset -f welcome_message

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if command -v brew &> /dev/null; then
  source "$(brew --prefix)/opt/zinit/zinit.zsh"
fi
source ~/.zsh/plugins.zsh


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
