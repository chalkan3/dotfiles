# State to install LunarVim via its official script

# Note: The actual dependencies for lvim are handled in packages.sls
install_lvim_from_script:
  cmd.run:
    - name: "bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install.sh) --yes"
    - runas: igor
    - creates: /home/igor/.local/bin/lvim
    - require:
      - pkg: core_packages
