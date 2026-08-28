{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

include:
  - repos.keyrings

nvim_ppa_key:
  cmd.run:
    - name: "curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9DBB0BE9366964F134855E2255F96FCF8231B6DD' | gpg --dearmor -o /etc/apt/keyrings/neovim-ppa.gpg"
    - creates: /etc/apt/keyrings/neovim-ppa.gpg
    - require:
      - file: ensure_keyrings_dir

nvim_ppa:
  file.managed:
    - name: /etc/apt/sources.list.d/neovim-ppa-ubuntu-unstable-{{ os_codename }}.sources
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Types: deb
        URIs: https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu/
        Suites: {{ os_codename }}
        Components: main
        Signed-By: /etc/apt/keyrings/neovim-ppa.gpg
    - require:
      - cmd: nvim_ppa_key
