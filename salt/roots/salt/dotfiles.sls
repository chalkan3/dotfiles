# State to clone the dotfiles repository and apply stow

# Ensure the dotfiles repo is cloned from GitHub
dotfiles_repo:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles.git
    - target: {{ salt['pillar.get']('home') }}/dotfiles
    - user: {{ salt['pillar.get']('user') }}
    - require:
      
      - pkg: core_packages

# Apply stow for dotfiles
# Apply stow for dotfiles
# Apply stow for dotfiles
apply_stow:
  cmd.run:
    - name: |
        stow --dir={{ salt['pillar.get']('home') }}/dotfiles zsh
        stow --dir={{ salt['pillar.get']('home') }}/dotfiles kitty
        stow --dir={{ salt['pillar.get']('home') }}/dotfiles lvim
        stow --dir={{ salt['pillar.get']('home') }}/dotfiles git
        stow --dir={{ salt['pillar.get']('home') }}/dotfiles zellij
    - runas: {{ salt['pillar.get']('user') }}
    - require:
      - git: dotfiles_repo


