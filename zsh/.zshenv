if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Source machine-specific exports
if [ -f "$HOME/.config/zsh/exports.zsh" ]; then
  . "$HOME/.config/zsh/exports.zsh"
fi
