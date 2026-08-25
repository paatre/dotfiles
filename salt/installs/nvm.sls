{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

install_nvm:
  cmd.run:
    - name: 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
    - runas: {{ user }}
    - creates: {{ home }}/.nvm/nvm.sh
