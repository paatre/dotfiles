include:
  - packages.dev

install_tree_sitter_cli:
  cmd.run:
    - name: 'npm install --global --no-fund --no-audit tree-sitter-cli'
    - unless: 'printf "0.26.1\n%s\n" "$(tree-sitter --version 2>/dev/null | cut -d" " -f2)" | sort -V -C'
    - require:
      - pkg: install_dev_packages
