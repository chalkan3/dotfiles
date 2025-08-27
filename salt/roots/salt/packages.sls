# State to ensure core packages are installed

core_packages:
  pkg.installed:
    - pkgs:
      - zsh
      - kitty
      - stow
      - git
      - neovim
      - tmux
      # Adicione outros pacotes que você precisa aqui
      - curl
      - wget
