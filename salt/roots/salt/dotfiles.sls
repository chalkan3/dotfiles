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
apply_stow_zsh:
  cmd.run:
    - name: cd {{ salt['pillar.get']('home') }}/dotfiles && stow zsh
    - runas: {{ salt['pillar.get']('user') }}

apply_stow_kitty:
  cmd.run:
    - name: cd {{ salt['pillar.get']('home') }}/dotfiles && stow kitty
    - runas: {{ salt['pillar.get']('user') }}

apply_stow_lvim:
  cmd.run:
    - name: cd {{ salt['pillar.get']('home') }}/dotfiles && stow lvim
    - runas: {{ salt['pillar.get']('user') }}

apply_stow_git:
  cmd.run:
    - name: cd {{ salt['pillar.get']('home') }}/dotfiles && stow git
    - runas: {{ salt['pillar.get']('user') }}

apply_stow_zellij:
  cmd.run:
    - name: cd {{ salt['pillar.get']('home') }}/dotfiles && stow zellij
    - runas: {{ salt['pillar.get']('user') }}


