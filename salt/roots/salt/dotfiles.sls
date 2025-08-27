# State to clone the dotfiles repository and apply stow

# Ensure the dotfiles repo is cloned from GitHub
dotfiles_repo:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles.git
    - target: /home/chalkan3/dotfiles
    - user: chalkan3
    - require:
      - user: chalkan3_user
      - pkg: core_packages

# List of stow packages (must match directory names in the dotfiles repo)
{% set stow_packages = ['zsh', 'kitty', 'git', 'lvim', 'zellij'] %}

# Run stow for each package
stow_dotfiles:
  cmd.run:
    - names:
      {% for package in stow_packages %}
      - stow {{ package }}
      {% endfor %}
    - cwd: /home/chalkan3/dotfiles
    - runas: chalkan3
    - require:
      - git: dotfiles_repo
      - pkg: core_packages
