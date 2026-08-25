install_starship:
  cmd.run:
    - name: 'curl -sS https://starship.rs/install.sh | sh -s -- -y'
    - creates: /usr/local/bin/starship
