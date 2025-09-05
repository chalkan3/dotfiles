# State to ensure core packages are installed

core_packages:
  pkg.installed:
    - pkgs:
      - zsh
      - kitty
      - stow
      - build-essential
      - git
      - ruby
      - curl
      - wget
      
      - python3
      - python3-pip
      - fzf
      - python3-pytest
      - python3-testinfra
      - openssh-client
      - openssh-server
      - ufw
      - auditd
      - nmap
      - tcpdump
      - mtr-tiny
      - dnsutils
      - net-tools
      - htop
      - iotop
      - sysstat
      - jq
      - bat
      - fd-find
      - ripgrep

bat_symlink:
  file.symlink:
    - name: /usr/local/bin/bat
    - target: /usr/bin/batcat
    - require:
      - pkg: core_packages

fd_symlink:
  file.symlink:
    - name: /usr/local/bin/fd
    - target: /usr/bin/fdfind
    - require:
      - pkg: core_packages


download_neovim_tarball:
  cmd.run:
    - name: wget -nv --show-progress --progress=bar:force:noscroll -O /tmp/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
    - cwd: /tmp

extract_neovim_tarball:
  cmd.run:
    - name: tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C /tmp
    - cwd: /tmp
    - require:
      - cmd: download_neovim_tarball

install_neovim_runtime:
  cmd.run:
    - name: mv /tmp/nvim-linux-x86_64 /opt/nvim
    - require:
      - cmd: extract_neovim_tarball
    - unless: test -d /opt/nvim

neovim_symlink:
  file.symlink:
    - name: /usr/local/bin/nvim
    - target: /opt/nvim/bin/nvim
    - force: True
    - require:
      - cmd: install_neovim_runtime

clean_neovim_tarball:
  file.absent:
    - name: /tmp/nvim-linux-x86_64.tar.gz
    - onchanges:
      - cmd: install_neovim_runtime

clean_neovim_extracted_dir:
  file.absent:
    - name: /tmp/nvim-linux-x86_64
    - onchanges:
      - cmd: install_neovim_runtime

download_zellij_tarball:
  cmd.run:
    - name: wget -nv --show-progress --progress=bar:force:noscroll -O /tmp/zellij.tar.gz https://github.com/zellij-org/zellij/releases/download/v0.43.1/zellij-x86_64-unknown-linux-musl.tar.gz
    - cwd: /tmp
    - unless: test -f /tmp/zellij.tar.gz

extract_zellij_tarball:
  cmd.run:
    - name: tar -xzf /tmp/zellij.tar.gz -C /tmp
    - cwd: /tmp
    - require:
      - cmd: download_zellij_tarball
    - unless: test -f /tmp/zellij

install_zellij_binary:
  cmd.run:
    - name: mv /tmp/zellij /usr/local/bin/zellij
    - require:
      - cmd: extract_zellij_tarball
    - unless: test -f /usr/local/bin/zellij

clean_zellij_tarball:
  file.absent:
    - name: /tmp/zellij.tar.gz
    - require:
      - cmd: install_zellij_binary

clean_zellij_extracted_dir:
  file.absent:
    - name: /tmp/zellij
    - require:
      - cmd: install_zellij_binary

install_rustup:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - runas: {{ salt['pillar.get']('user') }}
    - creates: {{ salt['pillar.get']('home') }}/.cargo/bin/cargo
    - require:
      - pkg: core_packages