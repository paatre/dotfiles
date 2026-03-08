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
      - curl
      - firefox
      - fzf
      - git
      - jq
      - lxc
      - neovim
      - ripgrep
      - stow
      - tldr
      - tmux
      - unzip
      - zoxide
    - require:
      - file: mozilla_repo
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
