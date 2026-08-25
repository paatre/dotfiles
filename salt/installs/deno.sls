{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

include:
  - packages.core

install_deno:
  cmd.run:
    - name: 'curl -fsSL https://deno.land/install.sh | sh'
    - runas: {{ user }}
    - creates: {{ home }}/.deno/bin/deno
    - require:
      - pkg: install_core_packages
