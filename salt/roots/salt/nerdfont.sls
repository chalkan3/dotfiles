# Salt state to install Fira Code Nerd Font

# Garante que o diretório de fontes do usuário exista
user_font_directory:
  file.directory:
    - name: {{ salt['pillar.get']('home') }}/.local/share/fonts
    - user: {{ salt['pillar.get']('user') }}
    - makedirs: True

# Baixa o arquivo .zip da fonte Fira Code Nerd Font
fira_code_nerd_font_zip:
  file.managed:
    - name: /tmp/FiraCode.zip
    - source: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
    - source_hash: sha256=e4264a553965f6513e705a79623353662365345a367f58559a062ce93826583a
    - unless: test -f {{ salt['pillar.get']('home') }}/.local/share/fonts/FiraCodeNerdFont-Regular.ttf

# Extrai a fonte para o diretório de fontes do usuário
extract_fira_code_nerd_font:
  archive.extracted:
    - name: {{ salt['pillar.get']('home') }}/.local/share/fonts
    - source: /tmp/FiraCode.zip
    - user: {{ salt['pillar.get']('user') }}
    - if_missing: {{ salt['pillar.get']('home') }}/.local/share/fonts/FiraCodeNerdFont-Regular.ttf
    - require:
      - file: user_font_directory
      - file: fira_code_nerd_font_zip

# Atualiza o cache de fontes do sistema
update_font_cache:
  cmd.run:
    - name: fc-cache -f -v
    - onchanges:
      - archive: extract_fira_code_nerd_font
