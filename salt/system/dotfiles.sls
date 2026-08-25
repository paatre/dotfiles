{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

include:
  - packages.core
  - packages.dev

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
      - pkg: install_dev_packages
      - file: prep_stow_paths
