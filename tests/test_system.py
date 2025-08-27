# /home/igor/dotfiles/tests/test_system.py

# Testinfra automatically injects the 'host' fixture.
# It represents the target host being tested.

def test_user_chalkan3_exists(host):
    """Verify that the chalkan3 user exists with correct shell and home directory."""
    user = host.user("chalkan3")
    assert user.exists
    assert user.group == "chalkan3"  # Assuming primary group is same as username
    assert user.shell == "/bin/zsh"
    assert user.home == "/home/chalkan3"

def test_zsh_package_installed(host):
    """Verify that the zsh package is installed."""
    pkg = host.package("zsh")
    assert pkg.is_installed

def test_kitty_command_exists(host):
    """Verify that the kitty command is available in PATH."""
    cmd = host.check_output("which kitty")
    assert "/usr/bin/kitty" in cmd

def test_lvim_command_exists(host):
    """Verify that the lvim command is available in PATH."""
    cmd = host.check_output("which lvim")
    assert "/home/chalkan3/.local/bin/lvim" in cmd

def test_stow_symlinks_exist(host):
    """Verify that key dotfile symlinks created by stow exist and point correctly."""
    # Test .zshrc symlink
    zshrc_symlink = host.file("/home/chalkan3/.zshrc")
    assert zshrc_symlink.is_symlink
    assert zshrc_symlink.linked_to == "/home/chalkan3/dotfiles/zsh/.zshrc"

    # Test .config/kitty symlink
    kitty_config_symlink = host.file("/home/chalkan3/.config/kitty")
    assert kitty_config_symlink.is_symlink
    assert kitty_config_symlink.linked_to == "/home/chalkan3/dotfiles/kitty/.config/kitty"

    # Test .config/zsh symlink (from zsh package)
    zsh_config_symlink = host.file("/home/chalkan3/.config/zsh")
    assert zsh_config_symlink.is_symlink
    assert zsh_config_symlink.linked_to == "/home/chalkan3/dotfiles/zsh/.config/zsh"

def test_zellij_command_exists(host):
    """Verify that the zellij command is available in PATH."""
    cmd = host.check_output("which zellij")
    assert "/usr/bin/zellij" in cmd

def test_fzf_command_exists(host):
    """Verify that the fzf command is available in PATH."""
    cmd = host.check_output("which fzf")
    assert "/usr/bin/fzf" in cmd

def test_glab_command_exists(host):
    """Verify that the glab command is available in PATH."""
    cmd = host.check_output("which glab")
    assert "/usr/bin/glab" in cmd
