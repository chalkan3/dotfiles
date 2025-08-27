# State to ensure the user exists

chalkan3_user:
  user.present:
    - name: chalkan3
    - shell: /bin/zsh
    - home: /home/chalkan3
    - groups:
      - wheel
    - passwd: {{ pillar.user_password }}
    - require:
      - pkg: core_packages # Ensure zsh is installed before setting as shell