# ~/.config/zsh/wsl.zsh
# Specific settings for Windows Subsystem for Linux (WSL).

# --- Environment Variables ---
# For GUI applications
export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2; exit;}'):0.0
  
# For audio forwarding
export HOST_IP="$(ip route | awk '/^default/{print $3}')"
export PULSE_SERVER="tcp:$HOST_IP"

# --- Aliases ---
# Interact with the Windows clipboard
alias pbcopy='clip.exe'
alias pbpaste='powershell.exe -Command "Get-Clipboard"'
