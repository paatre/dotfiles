{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

install_pulumi:
  cmd.run:
    - name: 'curl -fsSL https://get.pulumi.com | sh'
    - runas: {{ user }}
    - creates: {{ home }}/.pulumi/bin/pulumi
