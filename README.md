# Chalkan3's Dotfiles

This repository contains my personal configuration files (dotfiles) for my development environment. The main goal is to easily replicate my setup across different machines.

## What's Inside?

- **Zsh (`.zshrc`, `.zsh/`)**: My main shell configuration, including aliases, functions, options, and plugins managed by `zinit`.
- **Powerlevel10k (`.p10k.zsh`)**: The configuration file for the Powerlevel10k Zsh theme.

## Installation

To use these dotfiles on a new machine, you can use the provided installation script.

**Prerequisites:**
- `git`
- `zsh` (and set it as your default shell)

**Steps:**

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/chalkan3/dotfiles.git ~/dotfiles
    ```

2.  **Run the installation script:**
    This script will create symbolic links for the configuration files in your home directory. It will also back up any existing files.
    ```bash
    cd ~/dotfiles
    ./install.sh
    ```

3.  **Restart your shell** for the changes to take effect.
