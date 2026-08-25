{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

install_tpm:
  cmd.run:
    - name: 'git clone https://github.com/tmux-plugins/tpm {{ home }}/.tmux/plugins/tpm'
    - runas: {{ user }}
    - creates: {{ home }}/.tmux/plugins/tpm
