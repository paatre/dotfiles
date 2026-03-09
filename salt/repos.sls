{% set os_codename = salt['grains.get']('oscodename', 'questing') %}

ensure_keyrings_dir:
  file.directory:
    - names:
      - /etc/apt/keyrings
      - /usr/share/keyrings
    - mode: 755
    - user: root
    - group: root

chrome_repo:
  cmd.run:
    - name: "curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg"
    - creates: /usr/share/keyrings/google-chrome.gpg
  file.managed:
    - name: /etc/apt/sources.list.d/google-chrome.list
    - contents: "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main"

docker_key:
  cmd.run:
    - name: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
    - creates: /etc/apt/keyrings/docker.gpg

docker_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/docker.list
    - contents: "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu {{ os_codename }} stable"
    - require:
      - cmd: docker_key

google_cloud_repo:
  cmd.run:
    - name: "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg"
    - creates: /usr/share/keyrings/cloud.google.gpg
  file.managed:
    - name: /etc/apt/sources.list.d/google-cloud-sdk.list
    - contents: "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main"

mozilla_key:
  cmd.run:
    - name: "curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | gpg --dearmor -o /etc/apt/keyrings/packages.mozilla.org.gpg"
    - creates: /etc/apt/keyrings/packages.mozilla.org.gpg

mozilla_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/mozilla.list
    - contents: "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main"
    - require:
      - cmd: mozilla_key

tailscale_key:
  cmd.run:
    - name: "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/{{ os_codename }}.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null"
    - creates: /usr/share/keyrings/tailscale-archive-keyring.gpg

tailscale_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/tailscale.list
    - contents: "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu {{ os_codename }} main"
    - require:
      - cmd: tailscale_key

vscode_key:
  cmd.run:
    - name: "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg"
    - creates: /usr/share/keyrings/microsoft.gpg

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

cappelikan_ppa:
  pkgrepo.managed:
    - name: ppa:cappelikan/ppa

git_ppa:
  pkgrepo.managed:
    - name: ppa:git-core/ppa

nvim_ppa:
  pkgrepo.managed:
    - name: ppa:neovim-ppa/unstable
