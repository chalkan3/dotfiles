# State to harden SSH configuration

sshd_config_path: /etc/ssh/sshd_config

ssh_hardening:
  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?PermitRootLogin.*
    - repl: PermitRootLogin no
    - require:
      - pkg: openssh # Ensure openssh is installed

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?PasswordAuthentication.*
    - repl: PasswordAuthentication no
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?ChallengeResponseAuthentication.*
    - repl: ChallengeResponseAuthentication no
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?UsePAM.*
    - repl: UsePAM yes
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?X11Forwarding.*
    - repl: X11Forwarding no
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?AllowTcpForwarding.*
    - repl: AllowTcpForwarding no
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?MaxAuthTries.*
    - repl: MaxAuthTries 3
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?ClientAliveInterval.*
    - repl: ClientAliveInterval 300
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?ClientAliveCountMax.*
    - repl: ClientAliveCountMax 0
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?PermitEmptyPasswords.*
    - repl: PermitEmptyPasswords no
    - require:
      - pkg: openssh

  file.replace:
    - name: {{ sshd_config_path }}
    - pattern: ^#?LoginGraceTime.*
    - repl: LoginGraceTime 60
    - require:
      - pkg: openssh

  service.running:
    - name: sshd
    - restart: True
    - watch:
      - file: {{ sshd_config_path }}
