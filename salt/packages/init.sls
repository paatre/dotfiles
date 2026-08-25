include:
  - packages.core
  - packages.dev
  - packages.desktop
  - packages.containers
  - packages.cloud
  - packages.fonts

install_core_packages:
  test.nop:
    - require:
      - pkg: install_core_packages
      - pkg: install_dev_packages
      - pkg: install_desktop_packages
      - pkg: install_container_packages
      - pkg: install_cloud_packages
      - pkg: install_font_packages
