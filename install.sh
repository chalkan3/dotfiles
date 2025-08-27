#!/bin/bash
# Bootstrap script for setting up a new Arch Linux machine.

set -e

# --- Colors and Emojis ---
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'
BOLD='\e[1m'

SLOTH_EMOJI="🦥"
CHECK_EMOJI="✅"
WARN_EMOJI="⚠️"
ERROR_EMOJI="❌"

# --- Functions for pretty logging ---
log_info() { echo -e "${CYAN}${BOLD}${SLOTH_EMOJI} INFO: ${RESET}${CYAN}$1${RESET}"; }
log_success() { echo -e "${GREEN}${BOLD}${CHECK_EMOJI} SUCESSO: ${RESET}${GREEN}$1${RESET}"; }
log_warn() { echo -e "${YELLOW}${BOLD}${WARN_EMOJI} AVISO: ${RESET}${YELLOW}$1${RESET}"; }
log_error() { echo -e "${RED}${BOLD}${ERROR_EMOJI} ERRO: ${RESET}${RED}$1${RESET}"; exit 1; }
log_step() { echo -e "\n${BLUE}${BOLD}--- PASSO: $1 ---${RESET}"; }

# --- Welcome Banner ---
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"

  _   _      _ _           _ _ _
 | | | | ___| | | ___  ___| | | |
 | |_| |/ _ \ | |/ _ \/ __| | | |
 |  _  |  __/ | |  __/\__ \ | | |
 |_| |_|\___|_|_|\___||___/_|_|_|

  ${SLOTH_EMOJI}  Seu ambiente Arch Linux, configurado com carinho! ${SLOTH_EMOJI}

EOF
echo -e "${RESET}"

# --- User Configuration ---
NEW_USERNAME="chalkan3"
DOTFILES_DIR="/home/${NEW_USERNAME}/dotfiles"

log_step "Verificando Acesso de Superusuário (sudo)"
log_info "Checando se você tem permissões de sudo..."
if ! sudo -v; then
    log_error "Acesso sudo é necessário. Por favor, execute este script com um usuário que tenha privilégios de sudo."
fi
log_success "Acesso sudo confirmado!"

log_step "Instalando Dependências Essenciais (Git, Salt, Python)"
log_info "Preparando o sistema para o bootstrap... Isso pode levar um momento. 🦥"
sudo pacman -S --noconfirm --needed git salt python || log_error "Falha ao instalar dependências essenciais. Verifique sua conexão ou repositórios."
log_success "Dependências essenciais instaladas!"

log_step "Clonando seu Repositório de Dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    log_info "Criando diretório home para ${NEW_USERNAME} e ajustando permissões..."
    sudo mkdir -p "/home/${NEW_USERNAME}" || log_error "Falha ao criar diretório home para ${NEW_USERNAME}."
    sudo chown "${NEW_USERNAME}":"${NEW_USERNAME}" "/home/${NEW_USERNAME}" || log_error "Falha ao ajustar permissões para ${NEW_USERNAME}."
    
    log_info "Clonando o repositório de dotfiles para ${DOTFILES_DIR}... 🦥"
    sudo -u "${NEW_USERNAME}" git clone https://github.com/chalkan3/dotfiles.git "$DOTFILES_DIR" || log_error "Falha ao clonar o repositório de dotfiles."
    log_success "Repositório de dotfiles clonado com sucesso!"
else
    log_warn "Repositório de dotfiles já existe em ${DOTFILES_DIR}. Pulando o clone."
fi

log_step "Preparando Pillar Temporário para o Salt"
log_info "Configurando Pillar temporário para a criação segura do usuário..."
TEMP_PILLAR_DIR="/tmp/salt_temp_pillar"
TEMP_PILLAR_FILE="${TEMP_PILLAR_DIR}/user.sls"

sudo mkdir -p "$TEMP_PILLAR_DIR" || log_error "Falha ao criar diretório temporário para Pillar."
sudo chmod 700 "$TEMP_PILLAR_DIR" || log_error "Falha ao ajustar permissões do diretório temporário."

# Write the temporary Pillar file with an empty password hash
# User will be created without a password, and instructed to set it manually.
USER_PASSWORD_HASH="!"

sudo bash -c "cat > \"$TEMP_PILLAR_FILE\" <<EOF
user_password: '$USER_PASSWORD_HASH'
EOF" || log_error "Falha ao escrever o arquivo Pillar temporário."

sudo chmod 600 "$TEMP_PILLAR_FILE" || log_error "Falha ao ajustar permissões do arquivo Pillar temporário."
log_success "Pillar temporário preparado!"

log_step "Aplicando Estados do Salt (Configuração Principal)"
log_info "O Salt está agora configurando seu sistema. Isso pode levar um tempo... 🦥"
sudo salt-call --local --config-dir="$DOTFILES_DIR/salt" --pillar-root="$TEMP_PILLAR_DIR" state.apply || log_error "Falha ao aplicar os estados do Salt. Verifique os logs acima."
log_success "Estados do Salt aplicados com sucesso! Seu ambiente está quase pronto!"

log_step "Finalizando e Limpando"
log_info "Removendo arquivos temporários do Pillar..."
sudo rm -rf "$TEMP_PILLAR_DIR" || log_warn "Falha ao remover arquivos temporários do Pillar. Limpeza manual pode ser necessária."
log_success "Limpeza concluída!"

echo -e "\n${GREEN}${BOLD}${CHECK_EMOJI} SETUP COMPLETO! ${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------${RESET}"
echo -e "${GREEN}Usuário ${NEW_USERNAME} foi criado. ${RESET}"
echo -e "${YELLOW}⚠️  Por favor, defina uma senha para ${NEW_USERNAME} executando:${RESET}"
echo -e "${CYAN}  sudo passwd ${NEW_USERNAME}${RESET}"
echo -e "${GREEN}Após definir a senha, você pode fazer login como ${NEW_USERNAME} e reiniciar seu shell.${RESET}"
echo -e "${GREEN}--------------------------------------------------------------------${RESET}"
