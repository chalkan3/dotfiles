# State to clone the dotfiles repository and apply stow

# Ensure the dotfiles repo is cloned from GitHub
dotfiles_repo:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles.git
    - target: {{ salt['pillar.get']('home') }}/dotfiles
    - user: {{ salt['pillar.get']('user') }}
    - require:
      
      - pkg: core_packages


