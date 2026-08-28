{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

include:
  - repos.keyrings

cappelikan_ppa_key:
  cmd.run:
    - name: "curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3AE27527713D2479DCAFFD58A89D7C1B2F76304D' | gpg --dearmor -o /etc/apt/keyrings/cappelikan-ppa.gpg"
    - creates: /etc/apt/keyrings/cappelikan-ppa.gpg
    - require:
      - file: ensure_keyrings_dir

cappelikan_ppa:
  file.managed:
    - name: /etc/apt/sources.list.d/cappelikan-ubuntu-ppa-{{ os_codename }}.sources
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Types: deb
        URIs: https://ppa.launchpadcontent.net/cappelikan/ppa/ubuntu/
        Suites: {{ os_codename }}
        Components: main
        Signed-By: /etc/apt/keyrings/cappelikan-ppa.gpg
    - require:
      - cmd: cappelikan_ppa_key
