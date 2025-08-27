# State to ensure the user exists

igor_user:
  user.present:
    - name: igor
    - shell: /bin/zsh
    - home: /home/igor
    # Garante que o usuário está no grupo 'wheel' para ter acesso sudo
    # Adapte os grupos conforme sua necessidade
    - groups:
      - wheel
