# Configuração do Powerlevel10k - Estilo "Rainbow" Cheio de Recursos

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p1k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # --- Prompt de Duas Linhas ---
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # --- Ícones ---
  typeset -g POWERLEVEL9K_MODE='nerdfont-v3'

  # --- Elementos do Prompt (Esquerda e Direita) ---
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # Ícone do SO
    dir                     # Diretório atual
    vcs                     # Status do Git
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # Status de saída
    command_execution_time  # Duração do comando
    background_jobs         # Jobs em background
    direnv                  # Direnv
    asdf                    # Versões de linguagens
    kubecontext             # Contexto Kubernetes
    terraform               # Workspace Terraform
    aws                     # Perfil AWS
    context                 # user@hostname
    time                    # Hora
  )

  # --- Estilo Geral ---
  typeset -g POWERLEVEL9K_BACKGROUND=0
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

  # --- Cores ---
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_COLOR=208

  # --- Diretório ---
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=255
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=255
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true

  # --- VCS (Git) ---
  typeset -g POWERLEVEL9K_VCS_BACKGROUND=2
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=255
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=255
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=255
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=220
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=255

  function my_git_formatter() {
    emulate -L zsh
    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi
    local res
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${VCS_STATUS_LOCAL_BRANCH//\%/%%}"
    fi
    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="#${VCS_STATUS_TAG//\%/%%}"
    fi
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] && res+="@${VCS_STATUS_COMMIT[1,8]}"
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+=":${VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD )) && res+=" ⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES )) && res+=" *${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION ]] && res+=" ${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED )) && res+=" +${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED )) && res+=" !${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED )) && res+=" ${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true

  # --- Outros Segmentos ---
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=2
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=255
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=255
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=236
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=255
  typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=5
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=255
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=236
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=255
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  # --- Prompt Final ---
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=255
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'

  # --- Conectores ---
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='└─ '

  # --- Instant Prompt ---
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # --- Finalização ---
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
