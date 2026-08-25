ensure_keyrings_dir:
  file.directory:
    - names:
      - /etc/apt/keyrings
      - /usr/share/keyrings
    - mode: 755
    - user: root
    - group: root
