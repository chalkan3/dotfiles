# State to clone the dotfiles repository and apply stow

# Ensure the dotfiles repo is cloned from GitHub
dotfiles_repo:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles.git
    - target: {{ salt['pillar.get']('home') }}/dotfiles
    - user: {{ salt['pillar.get']('user') }}
    - require:
      
      - pkg: core_packages

# List of stow packages (must match directory names in the dotfiles repo)
{% set stow_packages = ['zsh', 'kitty', 'git', 'lvim', 'zellij'] %}

# Run stow for each package
stow_dotfiles:
  cmd.run:
    - names:
      {% for package in stow_packages %}
      - stow -d {{ salt['pillar.get']('home') }}/dotfiles {{ package }}
      {% endfor %}
    - cwd: {{ salt['pillar.get']('home') }}
    - runas: {{ salt['pillar.get']('user') }}
    - require:
      - git: dotfiles_repo
      - pkg: core_packages


