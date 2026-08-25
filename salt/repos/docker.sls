{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

include:
  - repos.keyrings

docker_key:
  cmd.run:
    - name: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
    - creates: /etc/apt/keyrings/docker.gpg
    - require:
      - file: ensure_keyrings_dir

docker_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/docker.list
    - contents: "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu {{ os_codename }} stable"
    - require:
      - cmd: docker_key
