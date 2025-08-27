# State to clone the dotfiles repository and apply stow

# Ensure the dotfiles repo is cloned from GitHub
dotfiles_repo:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles.git
    - target: /home/igor/dotfiles
    - user: igor
    - require:
      - user: igor_user
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
    - cwd: /home/igor/dotfiles
    - runas: igor
    - require:
      - git: dotfiles_repo
      - pkg: core_packages
