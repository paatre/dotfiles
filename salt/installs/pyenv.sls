{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

install_pyenv:
  cmd.run:
    - name: "curl https://pyenv.run | bash"
    - runas: {{ user }}
    - creates: {{ home }}/.pyenv/bin/pyenv
