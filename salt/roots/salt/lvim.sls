# State to install LunarVim via its official script

# Note: The actual dependencies for lvim are handled in packages.sls
install_lvim_from_script:
  cmd.run:
    - name: |
        export NVM_DIR="{{ salt['pillar.get']('home') }}/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install.sh) --yes
    - runas: {{ salt['pillar.get']('user') }}
    - creates: {{ salt['pillar.get']('home') }}/.local/bin/lvim
    - require:
      - cmd: install_node_lts # Ensure NVM has installed Node.js LTS
    
