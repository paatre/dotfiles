{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

include:
  - repos.keyrings

git_ppa_key:
  cmd.run:
    - name: "curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF911AB184317630C59970973E363C90F8F1B6217' | gpg --dearmor -o /etc/apt/keyrings/git-core-ppa.gpg"
    - creates: /etc/apt/keyrings/git-core-ppa.gpg
    - require:
      - file: ensure_keyrings_dir

git_ppa:
  file.managed:
    - name: /etc/apt/sources.list.d/git-core-ubuntu-ppa-{{ os_codename }}.sources
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Types: deb
        URIs: https://ppa.launchpadcontent.net/git-core/ppa/ubuntu/
        Suites: {{ os_codename }}
        Components: main
        Signed-By: /etc/apt/keyrings/git-core-ppa.gpg
    - require:
      - cmd: git_ppa_key
