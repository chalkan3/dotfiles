# State to harden SSH configuration

harden_ssh_permit_root_login:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?PermitRootLogin.*
    - repl: PermitRootLogin no

harden_ssh_password_authentication:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?PasswordAuthentication.*
    - repl: PasswordAuthentication no

harden_ssh_challenge_response_authentication:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?ChallengeResponseAuthentication.*
    - repl: ChallengeResponseAuthentication no

harden_ssh_use_pam:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?UsePAM.*
    - repl: UsePAM yes

harden_ssh_x11_forwarding:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?X11Forwarding.*
    - repl: X11Forwarding no

harden_ssh_allow_tcp_forwarding:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?AllowTcpForwarding.*
    - repl: AllowTcpForwarding no

harden_ssh_max_auth_tries:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?MaxAuthTries.*
    - repl: MaxAuthTries 3

harden_ssh_client_alive_interval:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?ClientAliveInterval.*
    - repl: ClientAliveInterval 300

harden_ssh_client_alive_count_max:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?ClientAliveCountMax.*
    - repl: ClientAliveCountMax 0

harden_ssh_permit_empty_passwords:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?PermitEmptyPasswords.*
    - repl: PermitEmptyPasswords no

harden_ssh_login_grace_time:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^#?LoginGraceTime.*
    - repl: LoginGraceTime 60

sshd_service_running:
  service.running:
    - name: sshd
    - restart: True
    - require:
      - pkg: core_packages
    - watch:
      - file: /etc/ssh/sshd_config