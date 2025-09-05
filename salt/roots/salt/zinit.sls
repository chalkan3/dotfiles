# State to install Zinit (Zsh plugin manager)

zinit_repo:
  git.latest:
    - name: https://github.com/zdharma-continuum/zinit.git
    - target: {{ salt['pillar.get']('home') }}/.local/share/zinit/zinit.git
    - user: {{ salt['pillar.get']('user') }}
    - require:
      - pkg: core_packages
