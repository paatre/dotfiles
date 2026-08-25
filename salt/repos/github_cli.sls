include:
  - repos.keyrings

github_cli_key:
  cmd.run:
    - name: "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null"
    - creates: /usr/share/keyrings/githubcli-archive-keyring.gpg
    - require:
      - file: ensure_keyrings_dir

github_cli_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/github-cli.list
    - contents: "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
    - require:
      - cmd: github_cli_key
