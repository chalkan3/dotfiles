

install_nvm:
  cmd.run:
    - name: |
        NVM_INSTALL_DIR="{{ salt['pillar.get']('home') }}/.nvm"
        if [ ! -d "$NVM_INSTALL_DIR" ]; then
          git clone https://github.com/nvm-sh/nvm.git "$NVM_INSTALL_DIR"
          (cd "$NVM_INSTALL_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`)
        fi
    - runas: {{ salt['pillar.get']('user') }}
    - require:
      - pkg: core_packages # Ensure git is installed

install_node_lts:
  cmd.run:
    - name: |
        export NVM_DIR="{{ salt['pillar.get']('home') }}/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
    - runas: {{ salt['pillar.get']('user') }}
    - require:
      - cmd: install_nvm