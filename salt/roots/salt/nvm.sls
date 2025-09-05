install_nvm:
  cmd.run:
    - name: |
        if [ ! -d "{{ salt['pillar.get']('home') }}/.nvm" ]; then
          git clone https://github.com/nvm-sh/nvm.git {{ salt['pillar.get']('home') }}/.nvm
          cd {{ salt['pillar.get']('home') }}/.nvm
          git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
        fi
    - runas: {{ salt['pillar.get']('user') }}
    - unless: test -d "{{ salt['pillar.get']('home') }}/.nvm"
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
    - unless: nvm list --lts | grep -q "current" # Check if LTS is already installed and active