# ~/.zshrc - Arquivo Principal de Configuração do Zsh (Otimizado)

# --- 1. Carregador do Zinit (Gerenciador de Plugins) ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Instalando Zinit...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    print -P "%F{34}Concluído.%f"
fi
source "$ZINIT_HOME/zinit.zsh"

# --- 2. Carregamento das Configurações Pessoais ---
ZSH_CONFIG_DIR="$HOME/.config/zsh"
source "${ZSH_CONFIG_DIR}/options.zsh"
source "${ZSH_CONFIG_DIR}/exports.zsh"
source "${ZSH_CONFIG_DIR}/aliases.zsh"
source "${ZSH_CONFIG_DIR}/functions.zsh"
source "${ZSH_CONFIG_DIR}/keybindings.zsh"

# Carrega configurações específicas do WSL, se aplicável
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
  source "${ZSH_CONFIG_DIR}/wsl.zsh"
fi

# --- 3. Powerlevel10k (Tema do Prompt) ---
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- 4. Carregamento dos Plugins com Zinit (Otimizado) ---

# Anexos essenciais do Zinit
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# NVM (Node Version Manager) - Carregado de forma otimizada pelo Zinit
zinit snippet OMZ::plugins/nvm/nvm.plugin.zsh

# Plugins de UI e Utilitários Core
zinit light romkatv/powerlevel10k                     # O prompt
zinit light zsh-users/zsh-syntax-highlighting         # Realce de sintaxe
zinit light zsh-users/zsh-autosuggestions           # Autosugestões
zinit light zsh-users/zsh-history-substring-search    # Pesquisa no histórico (para atalhos)
zinit ice lucid wait'0'; zinit light zsh-users/zsh-completions # Auto-completar avançado

# Produtividade e Workflow
zinit light-mode for junegunn/fzf-bin junegunn/fzf # FZF (Fuzzy Finder)
zinit ice as"completion"; zinit light Aloxaf/fzf-tab # FZF para autocompletar com TAB
zinit ice as"program" lucid eval"zoxide init zsh"; zinit light ajeetdsouza/zoxide # zoxide (cd inteligente)
zinit ice as"program" lucid eval"direnv hook zsh"; zinit light direnv/direnv # direnv

# Ferramentas de Desenvolvimento
zinit ice on-load"zicompinit; zicdreplay" as"program" lucid for \
    ohmyzsh/ohmyzsh:lib/git.zsh \
    ohmyzsh/ohmyzsh:plugins/git/git.plugin.zsh

# GitLab CLI completions
zinit ice as"completion" lucid atclone"glab completion -s zsh > _glab" atpull"%atclone" src="_glab"
zinit light gitlabhq/cli