{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

include:
  - packages.containers

setup_docker_permissions:
  cmd.run:
    - name: |
        groupadd -f docker
        usermod -aG docker {{ user }}
        newgrp docker
    - require:
      - pkg: install_container_packages
