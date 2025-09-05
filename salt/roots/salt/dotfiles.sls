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

# Clean up existing Zsh config files before stowing
clean_zsh_config:
  cmd.run:
    - name: |
        rm -rf {{ salt['pillar.get']('home') }}/.zshrc
        rm -rf {{ salt['pillar.get']('home') }}/.zshenv
        rm -rf {{ salt['pillar.get']('home') }}/.p10k.zsh
        rm -rf {{ salt['pillar.get']('home') }}/.config/zsh
    - runas: {{ salt['pillar.get']('user') }}
    - cwd: {{ salt['pillar.get']('home') }}
    - require:
      - pkg: core_packages # Ensure rm is available

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
      - cmd: clean_zsh_config # Ensure cleanup happens first
      - git: dotfiles_repo
      - pkg: core_packages


