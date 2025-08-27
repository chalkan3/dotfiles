# State to configure UFW (Uncomplicated Firewall)

ufw_installed:
  pkg.installed:
    - name: ufw

ufw_enabled:
  service.running:
    - name: ufw
    - enable: True
    - require:
      - pkg: ufw_installed

ufw_default_deny_incoming:
  cmd.run:
    - name: ufw default deny incoming
    - unless: ufw status | grep "Default: deny (incoming)"
    - require:
      - service: ufw_enabled

ufw_default_allow_outgoing:
  cmd.run:
    - name: ufw default allow outgoing
    - unless: ufw status | grep "Default: allow (outgoing)"
    - require:
      - service: ufw_enabled

ufw_allow_ssh:
  cmd.run:
    - name: ufw allow ssh
    - unless: ufw status | grep "22/tcp (SSH)"
    - require:
      - service: ufw_enabled

ufw_reload:
  cmd.run:
    - name: ufw reload
    - onchanges:
      - cmd: ufw_default_deny_incoming
      - cmd: ufw_default_allow_outgoing
      - cmd: ufw_allow_ssh
