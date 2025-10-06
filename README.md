# 🏠 Chalkan3's Dotfiles

Configurações pessoais para um ambiente de desenvolvimento moderno e produtivo com suporte cross-platform.

```
  ██████╗██╗  ██╗ █████╗ ██╗     ██╗  ██╗ █████╗ ███╗   ██╗██████╗
 ██╔════╝██║  ██║██╔══██╗██║     ██║ ██╔╝██╔══██╗████╗  ██║╚════██╗
 ██║     ███████║███████║██║     █████╔╝ ███████║██╔██╗ ██║ █████╔╝
 ██║     ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══██║██║╚██╗██║ ╚═══██╗
 ╚██████╗██║  ██║██║  ██║███████╗██║  ██╗██║  ██║██║ ╚████║██████╔╝
  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝

              🦥 ... slow and steady ... 🦥
```

## ✨ Características

- 🎨 **Tema Tokyo Night** consistente em Neovim, Zellij e Kitty
- 🤖 **Auto-instalação** de ferramentas essenciais no primeiro uso
- 🐧 **Cross-platform**: macOS, Ubuntu/Debian, Arch Linux
- ⚡ **Performance otimizada** com lazy loading e caching
- 🔧 **170+ aliases** e 50+ funções customizadas
- 📦 **Gerenciamento modular** de configurações

## 🖥️ Sistemas Suportados

| Sistema | Package Manager | Status |
|---------|----------------|--------|
| macOS (Intel/Apple Silicon) | Homebrew | ✅ Completo |
| Ubuntu/Debian 20.04+ | apt | ✅ Completo |
| Arch Linux | pacman | ✅ Completo |
| Fedora/RHEL | dnf | ✅ Básico |

## 📦 O que está incluído?

### 🐚 Zsh
- **Gerenciador**: Zinit (instalação automática)
- **Tema**: Powerlevel10k com instant prompt
- **Plugins**:
  - `zsh-autosuggestions`: Sugestões baseadas no histórico
  - `fast-syntax-highlighting`: Highlighting de sintaxe
  - `zsh-history-substring-search`: Busca avançada no histórico
  - `fzf-tab`: Completions com fuzzy finding
  - `zsh-autopair`: Auto-fecha parênteses e aspas
  - `zsh-you-should-use`: Lembra de usar aliases

### 🛠️ Ferramentas CLI (Auto-instaladas)

O sistema detecta ferramentas faltantes e instala automaticamente:

| Ferramenta | Descrição | Comando |
|------------|-----------|---------|
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd (aprende seus hábitos) | `z`, `zi` |
| [eza](https://github.com/eza-community/eza) | Modern ls com icons e git status | `ls`, `ll`, `la`, `lt` |
| [bat](https://github.com/sharkdp/bat) | Better cat com syntax highlighting | `cat`, `less` |
| [fd](https://github.com/sharkdp/fd) | Faster find | `fd`, `find` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Better grep | `rg`, `grep` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `Ctrl+R`, `Ctrl+T` |
| [git-delta](https://github.com/dandavison/delta) | Better git diff | `git diff` |
| [direnv](https://github.com/direnv/direnv) | Auto load environment vars | automático |

### 📝 Neovim
- **Plugin Manager**: lazy.nvim
- **Tema**: Tokyo Night (transparente)
- **LSP**: Configuração completa com Mason
- **Features**:
  - Avante.nvim (integração Claude AI)
  - GitHub Copilot
  - Treesitter (syntax highlighting)
  - Telescope (fuzzy finder)
  - nvim-tree (file explorer)
  - Which-key (key bindings helper)
  - Git integration (fugitive, gitsigns, diffview)
  - Debug (nvim-dap)
  - Testing (neotest)

### 🪟 Kitty Terminal
- **Tema**: Tokyo Night
- **Font**: JetBrains Mono 18pt com ligatures
- **Features**:
  - Scrollback 100k linhas
  - Opacity 95%
  - Remote control habilitado
  - Keybindings macOS-style

### 📐 Zellij Terminal Multiplexer
- **Tema**: Tokyo Night (azul escuro)
- **Layouts**:
  - `dev`: 65% editor + 35% terminal/logs
  - `fullstack`: Code, server, database tabs
  - `ops`: Monitoring (htop, disk, network, docker)
  - `compact`: Minimal single-pane
- **Features**:
  - Scrollback 100k linhas
  - Session serialization
  - Status bar customizada

## 🚀 Instalação

### 1. Pré-requisitos

```bash
# macOS
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ubuntu/Debian
sudo apt update && sudo apt install -y git zsh curl wget

# Arch Linux
sudo pacman -Syu
sudo pacman -S git zsh curl wget base-devel
```

### 2. Clonar o Repositório

```bash
git clone https://github.com/chalkan3/dotfiles.git /tmp/dotfiles_clone
```

### 3. Instalar Configurações

```bash
cd /tmp/dotfiles_clone
./install.sh
```

### 4. Configurar Zsh como Shell Padrão

```bash
chsh -s $(which zsh)
```

### 5. Reiniciar Terminal

Ao abrir um novo terminal, o sistema irá:
1. Mostrar ASCII art de boas-vindas
2. Instalar Zinit automaticamente (se necessário)
3. Detectar e instalar ferramentas faltantes
4. Configurar tudo automaticamente

Exemplo de saída:
```
⚠️  Missing tools detected:
  • zoxide      smarter cd
  • eza         modern ls
  • bat         better cat
  ...

🔧 Auto-installing missing tools...
→ Installing zoxide...
  ✓ zoxide installed successfully
...
✓ Installation complete!
```

## 📚 Comandos Úteis

### Navegação
```bash
z projeto        # Vai para diretório mais usado com "projeto"
zi               # Seletor interativo de diretórios
..               # cd ..
...              # cd ../..
-                # cd -
```

### Arquivos
```bash
ls               # Lista com icons e cores (eza)
ll               # Lista detalhada com git status
la               # Lista incluindo ocultos
lt               # Lista em árvore
cat arquivo.js   # Mostra com syntax highlighting (bat)
```

### Git
```bash
g                # git
gs               # git status
ga               # git add
gc               # git commit
gp               # git push
gl               # git pull
glog             # git log bonito
```

### Docker
```bash
dps              # docker ps
dex              # docker exec -it
dprune           # docker system prune -af --volumes
```

### Zellij
```bash
zj               # zellij
zjdev            # Abre layout dev
zjfs             # Abre layout fullstack
zjops            # Abre layout ops
zjs              # Gerenciar sessões
```

### Utilidades
```bash
explore          # Explorador interativo de comandos
show comando     # Mostra o que um comando faz
reload           # Recarrega configuração zsh
edit-zshrc       # Edita .zshrc
zsh-help         # Lista aliases e funções
```

## 🔧 Estrutura

```
dotfiles/
├── .zsh/
│   ├── aliases.zsh       # 170+ aliases organizados
│   ├── functions.zsh     # 50+ funções úteis
│   ├── env.zsh           # Variáveis de ambiente
│   ├── options.zsh       # Opções do Zsh
│   ├── plugins.zsh       # Configuração Zinit
│   └── auto-install.zsh  # Sistema de auto-instalação
├── zshrc/
│   └── .zshrc            # Arquivo principal Zsh
├── nvim/
│   └── lua/
│       ├── config/       # Configurações gerais
│       └── plugins/      # Plugins (8 categorias)
├── kitty/
│   └── .config/kitty/
│       ├── kitty.conf
│       └── themes/
├── zellij/
│   └── .config/zellij/
│       ├── config.kdl
│       ├── themes/
│       └── layouts/
└── .env.example          # Template para variáveis secretas
```

## 🎨 Personalização

### Variáveis de Ambiente

Copie o template e adicione suas credenciais:

```bash
cp .env.example ~/.env
# Edite ~/.env com suas chaves API, tokens, etc
```

### Adicionar Aliases

Edite `~/.zsh/aliases.zsh`:

```bash
alias meucomando='comando --flags'
```

### Adicionar Funções

Edite `~/.zsh/functions.zsh`:

```bash
minhafunction() {
    echo "Olá!"
}
```

### Configurar Powerlevel10k

```bash
p10k configure
```

## 🐛 Troubleshooting

### "command not found: z"

O zoxide não está instalado. Abra um novo terminal para instalação automática ou instale manualmente:

```bash
# macOS
brew install zoxide

# Ubuntu
sudo apt install zoxide

# Arch
sudo pacman -S zoxide
```

### Warning do Powerlevel10k Instant Prompt

Já está corrigido! A mensagem de boas-vindas foi movida para o final do `.zshrc`.

### Aliases não funcionando

```bash
source ~/.zshrc
```

### Ubuntu: fd ou bat não encontrado

No Ubuntu, os comandos são `fdfind` e `batcat`. Os aliases automáticos já tratam isso, mas você pode criar symlinks:

```bash
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat
```

## 📝 Notas

### Auto-instalação

- Verifica ferramentas faltantes **1x por dia** (não deixa terminal lento)
- Cache em `~/.cache/zsh_auto_install_check`
- Instalação silenciosa em background
- Funciona em todos os sistemas suportados

### Compatibilidade Ubuntu

- **eza**: Adiciona repositório automaticamente
- **git-delta**: Instala via GitHub releases
- **fd-find**: Comando é `fdfind` (alias `fd` criado)
- **bat**: Comando é `batcat` (alias `bat` criado)

### Arch Linux

Todas as ferramentas estão nos repositórios oficiais. Nenhuma configuração adicional necessária.

## 🤝 Contribuindo

Sugestões e melhorias são bem-vindas! Abra uma issue ou pull request.

## 📄 Licença

MIT License - use à vontade!

## 🙏 Agradecimentos

Configurações inspiradas por:
- [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zdharma-continuum/zinit](https://github.com/zdharma-continuum/zinit)
- [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)
- Modern Unix tools community

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Made with ❤️ by chalkan3
