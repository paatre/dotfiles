include:
  - repos.docker

install_container_packages:
  pkg.installed:
    - pkgs:
      - containerd.io
      - docker-buildx-plugin
      - docker-ce
      - docker-ce-cli
      - docker-compose-plugin
    - require:
      - file: docker_repo
