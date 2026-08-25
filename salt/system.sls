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

configure_ptyxis:
  cmd.run:
    - name: |
        gsettings set org.gnome.Ptyxis font-name 'Cascadia Mono NF 12'
        gsettings set org.gnome.Ptyxis use-system-font false
        DEFAULT_UUID=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ custom-command 'tmux'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ label 'Default'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ palette 'Gruvbox'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ use-custom-command true
    - runas: {{ user }}
    - require:
      - cmd: deploy_dotfiles

setup_docker_permissions:
  cmd.run:
    - name: |
        groupadd -f docker
        usermod -aG docker {{ user }}
        newgrp docker
    - require:
      - pkg: install_core_packages
