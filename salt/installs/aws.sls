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
