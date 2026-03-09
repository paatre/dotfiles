{% set os_codename = salt['grains.get']('oscodename') %}

{% if not os_codename %}
  {% set os_codename = 'questing' %}
{% endif %}

{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

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

install_core_packages:
  pkg.installed:
    - pkgs:
      - btop
      - cargo
      - code
      - containerd.io
      - curl
      - docker-buildx-plugin
      - docker-ce
      - docker-ce-cli
      - docker-compose-plugin
      - firefox
      - firefox-nightly
      - flameshot
      - fonts-cascadia-code
      - fonts-firacode
      - fonts-powerline 
      - fzf
      - git
      - git-delta
      - git-filter-repo
      - gnome-tweaks
      - google-chrome-stable
      - google-cloud-cli
      - jq
      - lxc
      - ncdu
      - neovim
      - pass
      - ripgrep
      - stow
      - tailscale
      - tldr
      - tmux
      - unzip
      - whois
      - wl-clipboard
      - zoxide
    - require:
      - file: chrome_repo
      - file: google_cloud_repo
      - file: mozilla_repo
      - file: tailscale_repo
      - file: vscode_repo
      - pkgrepo: cappelikan_ppa
      - pkgrepo: git_ppa
      - pkgrepo: nvim_ppa

install_starship:
  cmd.run:
    - name: 'curl -sS https://starship.rs/install.sh | sh -s -- -y'
    - creates: /usr/local/bin/starship

install_nvm:
  cmd.run:
    - name: 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
    - runas: {{ user }}
    - creates: {{ home }}/.nvm/nvm.sh

install_pyenv:
  cmd.run:
    - name: "curl https://pyenv.run | bash"
    - runas: {{ user }}
    - creates: {{ home }}/.pyenv/bin/pyenv

install_deno:
  cmd.run:
    - name: 'curl -fsSL https://deno.land/install.sh | sh'
    - runas: {{ user }}
    - creates: {{ home }}/.deno/bin/deno
    - require:
      - pkg: install_core_packages # Ensures unzip is ready

install_pulumi:
  cmd.run:
    - name: 'curl -fsSL https://get.pulumi.com | sh'
    - runas: {{ user }}
    - creates: {{ home }}/.pulumi/bin/pulumi

install_ollama:
  cmd.run:
    - name: "curl -fsSL https://ollama.com/install.sh | sh"
    - creates: /usr/local/bin/ollama

install_opencode:
  cmd.run:
    - name: "curl -fsSL https://opencode.dev/install.sh | sh"
    - creates: /usr/local/bin/opencode

download_glab:
  cmd.run:
    - name: |
        rm -f /tmp/glab.deb
        GLAB_VER=$(curl -s "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases" | grep -Po '"tag_name":"v\K[^"]*' | head -n 1)
        if [ -z "$GLAB_VER" ]; then
          echo "Failed to fetch GLAB version from GitLab API"
        fi
        curl -sSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VER}/downloads/glab_${GLAB_VER}_linux_amd64.deb" -o /tmp/glab.deb
    - unless: test -f /usr/bin/glab

install_glab:
  pkg.installed:
    - sources:
      - glab: /tmp/glab.deb
    - require:
      - cmd: download_glab

install_slack:
  cmd.run:
    - name: |
        VERSION="4.47.69"
        URL="https://downloads.slack-edge.com/desktop-releases/linux/x64/${VERSION}/slack-desktop-${VERSION}-amd64.deb"
        curl -sL "$URL" -o /tmp/slack.deb
        apt-get update && apt-get install -y /tmp/slack.deb
    - unless: test -f /usr/bin/slack

extract_aws_cli:
  archive.extracted:
    - name: /tmp/awscli
    - source: https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
    - skip_verify: True
    - enforce_toplevel: False

install_aws_cli:
  cmd.run:
    - name: "sudo ./aws/install --update"
    - cwd: /tmp/awscli
    - creates: /usr/local/bin/aws
    - require:
      - archive: extract_aws_cli

prep_stow_paths:
  file.absent:
    - names:
      - {{ home }}/.bashrc
      - {{ home }}/.bash_logout
      - {{ home }}/.bash_profile
      - {{ home }}/.profile
      - {{ home }}/.vimrc

lxd_bridge_firewall_fix:
  file.managed:
    - name: /etc/NetworkManager/dispatcher.d/lxd-bridge-fix
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - contents: |
        #!/bin/sh

        IFACE=$1
        ACTION=$2

        if [ "$IFACE" = "lxdbr0" ] && [ "$ACTION" = "up" ]; then
            if ! nft list chain ip filter FORWARD | grep -q 'oifname "lxdbr0" accept'; then
                nft insert rule ip filter FORWARD oifname "lxdbr0" accept
            fi

            if ! nft list chain ip filter FORWARD | grep -q 'iifname "lxdbr0" accept'; then
                nft insert rule ip filter FORWARD iifname "lxdbr0" accept
            fi
        fi

deploy_dotfiles:
  cmd.run:
    - name: >
        stow -R -t {{ home }}
        bash
        bpytop
        fd
        fzf
        git
        gnome-terminal 
        nvim
        starship
        tmux
        ubuntu
        vim
    - cwd: {{ home }}/dotfiles
    - runas: {{ user }}
    - require:
      - pkg: install_core_packages
      - file: prep_stow_paths
