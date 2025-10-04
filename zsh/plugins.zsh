# This file loads Zinit plugins and is sourced by ~/.zshrc after the 'zinit' function is defined.

# -----------------------------------------------------------
# 1. CRITICAL SYNCHRONOUS LOADING (P10k & Completions)
# These must load quickly and correctly before the prompt appears.
# -----------------------------------------------------------

# Load Powerlevel10k first with minimal depth for speed.
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load zsh-completions with necessary setup (compinit and compdreplay)
# The 'blockf' ice is often needed to correctly initialize completions.
zinit ice lucid wait'0' blockf atinit"zicompinit; zicdreplay" \
    zinit light zsh-users/zsh-completions

# -----------------------------------------------------------
# 2. ANNEXES (EXTENSIONS)
# Loaded using the efficient 'light-mode for' syntax.
# -----------------------------------------------------------

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# -----------------------------------------------------------
# 3. ASYNCHRONOUS LOADING (Other Plugins)
# The 'wait lucid' runs these plugins in the background, speeding up startup.
# -----------------------------------------------------------

zinit wait lucid light-mode for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-history-substring-search \
    mafredri/zsh-async
