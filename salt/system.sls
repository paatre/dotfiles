{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

include:
  - packages

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
