# ⌨️  Guia de Atalhos do Terminal

Referência rápida para navegação eficiente no terminal Zsh.

## 🏃 Navegação entre Palavras

| Atalho | Ação |
|--------|------|
| `Option + →` ou `Option + f` | Próxima palavra |
| `Option + ←` ou `Option + b` | Palavra anterior |
| `Ctrl + →` | Próxima palavra (alternativo) |
| `Ctrl + ←` | Palavra anterior (alternativo) |

**Exemplo:**
```bash
cd /usr/local/bin/python3
   ↑  ↑    ↑     ↑    ↑
   Use Option+→ para pular entre cada parte
```

## 🎯 Início e Fim da Linha

| Atalho | Ação |
|--------|------|
| `Ctrl + a` | Vai para o **início** da linha |
| `Ctrl + e` | Vai para o **fim** da linha |
| `Home` | Início da linha |
| `End` | Fim da linha |

**Exemplo:**
```bash
                              ┌─ Cursor aqui
echo "Hello World" | grep -i hello
│
└─ Ctrl+a move para cá
```

## ✂️  Deletar Palavras

| Atalho | Ação |
|--------|------|
| `Ctrl + w` | Deleta palavra **anterior** |
| `Option + d` | Deleta palavra **seguinte** |
| `Option + Backspace` | Deleta palavra anterior (alternativo) |
| `Ctrl + Delete` | Deleta palavra seguinte |

**Exemplo:**
```bash
# Cursor aqui ↓
git commit -m "fix bug in authentication"
# Ctrl+w deleta "authentication"
# Option+d deletaria "bug"
```

## 🗑️  Deletar Linhas Inteiras

| Atalho | Ação |
|--------|------|
| `Ctrl + k` | Deleta do cursor até o **fim** da linha |
| `Ctrl + u` | Deleta do cursor até o **início** da linha |
| `Ctrl + c` | Cancela comando e limpa linha |

**Exemplo:**
```bash
          ┌─ Cursor aqui
ls -la /home/user/documents/work
       │                      │
       └─ Ctrl+u deleta isso ┘
       ┌─ Ctrl+k deletaria isso ─┘
```

## 📋 Clipboard (Kill Ring)

O Zsh mantém um histórico de textos deletados que você pode reutilizar:

| Atalho | Ação |
|--------|------|
| `Ctrl + y` | Cola último texto deletado (**yank**) |
| `Option + y` | Circula entre textos deletados anteriores |

**Exemplo:**
```bash
# 1. Digite e delete com Ctrl+w
rm file1.txt
# Deletou "file1.txt"

# 2. Digite novo comando
mv <Ctrl+y>
# Cola "file1.txt": mv file1.txt
```

## 🔄 Manipulação de Texto

| Atalho | Ação |
|--------|------|
| `Ctrl + t` | Troca letra atual com anterior |
| `Option + t` | Troca palavra atual com anterior |
| `Option + u` | Palavra atual para MAIÚSCULAS |
| `Option + l` | Palavra atual para minúsculas |
| `Option + c` | Capitaliza palavra atual |

**Exemplos:**
```bash
# Corrigir typo com Ctrl+t
clera → cle[r]a → Ctrl+t → clear

# Inverter ordem com Option+t
mkdir folder new → mkdir new folder

# Mudar case com Option+u
echo hello → echo HELLO
```

## 🔍 Busca no Histórico

| Atalho | Ação |
|--------|------|
| `Ctrl + r` | Busca **reversa** no histórico (fzf) |
| `↑` (seta cima) | Comando anterior (busca por prefixo) |
| `↓` (seta baixo) | Próximo comando |
| `Ctrl + g` | Cancela busca no histórico |

**Exemplo:**
```bash
# Digite parte do comando e pressione Ctrl+r
git pus<Ctrl+r>
# Mostra: git push origin main (último comando com "pus")
```

## 🔙 Desfazer

| Atalho | Ação |
|--------|------|
| `Ctrl + _` | Desfaz última edição |
| `Ctrl + /` | Desfaz última edição (alternativo) |

**Exemplo:**
```bash
echo "test"
# Deletou tudo com Ctrl+u
# Ctrl+_ restaura: echo "test"
```

## ✏️  Editar no Editor

| Atalho | Ação |
|--------|------|
| `Ctrl + x` → `Ctrl + e` | Abre comando atual no `$EDITOR` (nvim) |

**Útil para:** comandos longos, scripts multilinhas, editar histórico

## 🎨 Completions

| Atalho | Ação |
|--------|------|
| `Tab` | Completa comando/arquivo |
| `Tab` `Tab` | Mostra todas as opções (com fzf) |
| `Ctrl + Space` | Aceita sugestão (zsh-autosuggestions) |
| `→` (seta direita) | Aceita sugestão completa |
| `Ctrl + →` | Aceita próxima palavra da sugestão |

## 📝 Cheat Sheet Rápido

### Movimentação Básica
```
Ctrl + a    ← Início       Fim → Ctrl + e
Ctrl + ←    ← Palavra    Palavra → Ctrl + →
```

### Deletar
```
Ctrl + w    ← Palavra    Palavra → Option + d
Ctrl + u    ← Linha      Linha → Ctrl + k
```

### Clipboard
```
Ctrl + w    Deletar palavra (guarda no clipboard)
Ctrl + y    Colar de volta
```

### Busca
```
Ctrl + r    Buscar no histórico (fzf)
↑ ↓         Navegar histórico
```

## 🎯 Dicas Profissionais

### 1. Construir Comandos Complexos
```bash
# Use Ctrl+x Ctrl+e para comandos longos
find . -type f -name "*.log" | \
  xargs grep -l "error" | \
  while read file; do
    echo "Processing $file"
  done
```

### 2. Reutilizar Argumentos
```bash
mkdir /long/path/to/directory
cd !$  # !$ = último argumento do comando anterior
# ou use Option+. para ciclar entre últimos argumentos
```

### 3. Corrigir Comandos Rapidamente
```bash
gti status         # Typo!
# Ctrl+a → Ctrl+→ → Ctrl+t
# Vira: git status
```

### 4. Workflow com Kill Ring
```bash
# 1. Construir lista de arquivos
ls file1.txt file2.txt file3.txt

# 2. Deletar cada arquivo com Ctrl+w (salva no kill ring)
# 3. Construir novo comando
rm <Ctrl+y> <Ctrl+y> <Ctrl+y>
# Resultado: rm file3.txt file2.txt file1.txt
```

## 🔧 Configuração no macOS

**Importante:** No Kitty, certifique-se que Option funciona como Meta key:

```conf
# ~/.config/kitty/kitty.conf
macos_option_as_alt yes
```

Já está configurado! ✅

## 📚 Referências

- **Modo Emacs**: Padrão do Zsh (atual)
- **Modo Vi**: Para usar Vi keybindings, adicione `bindkey -v` no `.zshrc`

Para ver todos os bindings:
```bash
bindkey  # Lista todos os keybindings ativos
```

---

💡 **Pratique um atalho por dia até virar músculo memória!**

Comece com: `Option+→/←` (navegação entre palavras) e `Ctrl+a/e` (início/fim)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
