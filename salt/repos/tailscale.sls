{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

include:
  - repos.keyrings

tailscale_key:
  cmd.run:
    - name: "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/{{ os_codename }}.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null"
    - creates: /usr/share/keyrings/tailscale-archive-keyring.gpg
    - require:
      - file: ensure_keyrings_dir

tailscale_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/tailscale.list
    - contents: "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu {{ os_codename }} main"
    - require:
      - cmd: tailscale_key
