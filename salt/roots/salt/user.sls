# State to ensure the user exists

{% if grains['os_family'] == 'Debian' %}
  {% set admin_group = 'sudo' %}
{% else %}
  {% set admin_group = 'wheel' %}
{% endif %}

chalkan3_user:
  user.present:
    - name: chalkan3
    - shell: /bin/zsh
    - home: /home/chalkan3
    - groups:
      - {{ admin_group }}
    
    - require:
      - pkg: core_packages # Ensure zsh is installed before setting as shell