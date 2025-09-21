# 🦥 My Arch Linux Dotfiles 🦥

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Welcome to my personal Arch Linux dotfiles repository! This repository contains my highly personalized configuration files for various applications, managed using **GNU Stow**.

---

## ✨ What's Inside?

This repository is a collection of configuration files for my development environment, including:

*   **Zsh Configuration:** Custom `.zshrc`, aliases, functions, keybindings, and options.
*   **Terminal Emulator:** `Kitty` terminal configurations (themes, keybinds, UI settings).
*   **Text Editor:** `LunarVim` (Neovim distribution) configurations.
*   **Terminal Multiplexer:** `Zellij` configurations.
*   **Git Configuration:** Global `.gitconfig` settings.
*   **And more!** (e.g., `p10k.zsh`, `zshenv`)

---

## 🚀 How to Use These Dotfiles

These dotfiles are designed to be deployed and managed by **SaltStack** via a separate bootstrap repository.

**Do NOT clone this repository directly and try to use `stow` manually.**

### Recommended Setup Process:

1.  **Bootstrap Your System:**
    Start by using the [chalkan3/bootstrap](https://github.com/chalkan3/bootstrap) repository. This repository contains an `install.sh` script that will:
    *   Install essential system dependencies (including SaltStack).
    *   Create the dedicated `chalkan3` user.
    *   Set up the initial system configurations.
    *   **Automatically clone this `chalkan3/dotfiles` repository** into your home directory (`~/dotfiles`) and apply all configurations using SaltStack and GNU Stow.

    Refer to the [chalkan3/bootstrap README](https://github.com/chalkan3/bootstrap#getting-started-quick-setup) for detailed instructions on how to get started.

2.  **Manage Your Dotfiles (After Bootstrap):**
    Once the initial setup is complete, your dotfiles will be located in `~/dotfiles`. You can make changes directly within this directory.

    ```bash
    cd ~/dotfiles
    # Edit your files, e.g., lvim/.config/lvim/config.lua
    ```

    After making changes, remember to commit and push them to this GitHub repository to keep your configurations version-controlled and synchronized across machines.

    ```bash
    git add .
    git commit -m "feat: My awesome dotfile change"
    git push
    ```

---

## 🏗️ Architecture Overview

This repository is a component of a larger, automated development environment setup.

*   **chalkan3/bootstrap:** (Separate Repository)
    *   Contains the `install.sh` script and all **SaltStack** states.
    *   Responsible for initial system provisioning, user creation, and orchestrating the deployment of these dotfiles.
*   **chalkan3/dotfiles:** (This Repository)
    *   Contains only the raw configuration files.
    *   Deployed by SaltStack from the `chalkan3/bootstrap` repository.
    *   Uses **GNU Stow** for managing symbolic links from `~/dotfiles/<package_name>/` to the appropriate locations in your home directory (e.g., `~/.zshrc`, `~/.config/kitty`).

### Repository Structure (of this `dotfiles` repository)

```
.
├── git/                        # Stow package for Git configuration
├── kitty/                      # Stow package for Kitty terminal configuration
├── lvim/                       # Stow package for LunarVim configuration
├── zellij/                     # Stow package for Zellij configuration
└── zsh/                        # Stow package for Zsh configuration (.zshrc, .config/zsh)
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ and 🦥 by chalkan3
</p>