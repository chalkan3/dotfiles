# 🦥 My Arch Linux Dotfiles 🦥

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Welcome to my personal Arch Linux dotfiles repository! This project aims to provide a fully automated and reproducible setup for my development environment using **SaltStack** for system provisioning and **GNU Stow** for managing symbolic links of configuration files.

---

## ✨ Features

This repository sets up a highly personalized and functional Arch Linux environment, including:

*   **Automated User Creation:** Securely creates a dedicated user (`chalkan3`) during setup.
*   **Essential System Dependencies:** Installs core packages like `git`, `zsh`, `kitty`, `zellij`, `neovim`, `ruby`, `nodejs`, `python`, `fzf`, `glab`, and more.
*   **Security Hardening:** Configures `UFW` firewall and hardens `SSH` for a more secure system.
*   **Zsh Configuration:** Sets up `zsh` with `Powerlevel10k` theme, `zsh-syntax-highlighting`, `zsh-autosuggestions`, and other productivity plugins via `Zinit`.
*   **Terminal Emulator:** Configures `Kitty` with custom themes and settings.
*   **Text Editor:** Installs and configures `LunarVim` (a Neovim distribution) for a powerful editing experience.
*   **Terminal Multiplexer:** Sets up `Zellij` for efficient terminal session management.
*   **Dotfile Management:** Uses `GNU Stow` to neatly organize and symlink configuration files from this repository to your home directory.
*   **Secure Setup:** Handles sensitive data (like user passwords) securely without committing them to Git.

---

## 🚀 Getting Started (Quick Setup)

To bootstrap a fresh Arch Linux installation with these dotfiles, simply run the following command as your initial user (who has `sudo` privileges):

```bash
curl -L https://raw.githubusercontent.com/chalkan3/dotfiles/master/install.sh | sh
```

**What this command does:**
1.  Downloads the `install.sh` script.
2.  Executes the script, which will:
    *   Check for `sudo` access.
    *   Install `git`, `salt`, and `python` via `pacman`.
    *   Create the user `chalkan3` (if it doesn't exist).
    *   Clone this dotfiles repository into `/home/chalkan3/dotfiles`.
    *   Apply all **SaltStack** states to install remaining dependencies, configure the system, and run `stow`.

---

## 📝 Post-Installation Steps

After the `install.sh` script completes:

1.  **Set Password for `chalkan3`:**
    The script creates the `chalkan3` user without an initial password for security. You **must** set a password for this user:
    ```bash
    sudo passwd chalkan3
    ```
2.  **Log In:**
    You can now log in as `chalkan3`.
3.  **Restart Shell / Source `.zshrc`:**
    Once logged in as `chalkan3`, open a new terminal. Your `.zshrc` will automatically load, and `Zinit` will proceed to install all Zsh plugins and themes (like Powerlevel10k). This might take a few moments.

---

## 🏗️ Architecture Overview

This project leverages a powerful combination of tools for robust and reproducible environment management:

*   **SaltStack (Masterless Mode):**
    *   Used for system provisioning, package installation, user creation, and orchestrating the entire setup process.
    *   Runs in "masterless" mode, meaning each machine acts as its own Salt master and minion, applying configurations locally.
    *   Salt states are defined in the `salt/` directory.
*   **GNU Stow:**
    *   Manages symbolic links for dotfiles. Each application's configuration (e.g., `zsh`, `kitty`, `lvim`) resides in its own directory within this repository.
    *   When `stow <package_name>` is run, it creates symlinks from `~/dotfiles/<package_name>/` to the appropriate locations in your home directory (e.g., `~/.zshrc`, `~/.config/kitty`).

### Repository Structure

```
.
├── install.sh                  # The main bootstrap script to run
├── README.md                   # You are here!
├── salt/                       # SaltStack configuration
│   ├── minion.conf             # Salt minion configuration for masterless mode
│   └── roots/                  # Salt state tree root
│       └── salt/               # Main Salt states directory
│           ├── top.sls         # Orchestrates which states to apply
│           ├── packages.sls    # Defines system packages to install
│           ├── user.sls        # Manages user creation (chalkan3)
│           ├── lvim.sls        # Installs LunarVim
│           └── dotfiles.sls    # Clones repo and runs stow for each package
├── bash/                       # Stow package for Bash (currently removed)
├── git/                        # Stow package for Git configuration
├── kitty/                      # Stow package for Kitty terminal configuration
├── lvim/                       # Stow package for LunarVim configuration
├── nvim/                       # Stow package for Neovim (currently removed)
├── tmux/                       # Stow package for Tmux (currently removed)
├── zellij/                     # Stow package for Zellij configuration
└── zsh/                        # Stow package for Zsh configuration (.zshrc, .config/zsh)
```

---

## 🛠️ Managing Your Dotfiles

Once the initial setup is complete, you can manage your dotfiles directly from this repository:

1.  **Navigate to the dotfiles directory:**
    ```bash
    cd ~/dotfiles
    ```
2.  **Make changes:** Edit the configuration files within their respective package directories (e.g., `zsh/.zshrc`, `kitty/.config/kitty/kitty.conf`).
3.  **Apply changes (if needed):** For changes to take effect, you might need to:
    *   Restart the application (e.g., open a new terminal for Zsh changes).
    *   For `stow` related changes (e.g., adding new files to a package), you might need to `stow -R <package_name>` or `stow <package_name>` from `~/dotfiles`.
4.  **Commit and Push:** Remember to commit your changes and push them to your GitHub repository to keep your dotfiles version-controlled and synchronized across machines.
    ```bash
    git add .
    git commit -m "feat: My awesome dotfile change"
    git push
    ```

### Updating System Dependencies / Re-applying Salt States

If you modify Salt states (e.g., add new packages to `packages.sls`), you can re-apply the Salt configuration:

```bash
sudo salt-call --local --config-dir="~/dotfiles/salt" state.apply
```

---

## 🔒 Security Note

*   This repository **does not** store any sensitive information like SSH keys, GPG keys, or personal passwords.
*   The `install.sh` script handles user password creation securely by prompting for it during execution and passing it to Salt via a temporary, non-persisted Pillar.

---

## ✅ Automated Testing

This project includes automated tests using **Testinfra** (built on `pytest`) to ensure the system is configured as expected after the Salt states are applied.

*   Tests are located in the `tests/` directory.
*   They verify user creation, package installations, command availability, and `stow` symlinks.
*   Tests are automatically executed as the final step of the `install.sh` script.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ and 🦥 by chalkan3
</p>
