install_opencode:
  cmd.run:
    - name: "curl -fsSL https://opencode.ai/install | bash"
    - creates: /usr/local/bin/opencode
