include:
  - repos.keyrings

vscode_key:
  cmd.run:
    - name: "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg"
    - creates: /usr/share/keyrings/microsoft.gpg
    - require:
      - file: ensure_keyrings_dir

vscode_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/vscode.sources
    - contents: |
        Types: deb
        URIs: https://packages.microsoft.com/repos/code
        Suites: stable
        Components: main
        Architectures: amd64,arm64,armhf
        Signed-By: /usr/share/keyrings/microsoft.gpg
    - require:
      - cmd: vscode_key
