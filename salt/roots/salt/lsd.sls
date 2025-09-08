# salt/roots/salt/lsd.sls

# Instalação robusta do LSD via download direto do .deb
install_lsd_from_deb:
  cmd.run:
    - name: |
        wget https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb -O /tmp/lsd.deb
        sudo dpkg -i /tmp/lsd.deb
        rm /tmp/lsd.deb
    - unless: command -v lsd
