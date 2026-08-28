include:
  - repos.github_cli
  - repos.git_ppa
  - repos.neovim_ppa

install_dev_packages:
  pkg.installed:
    - pkgs:
      - cargo
      - gh
      - git
      - git-delta
      - git-filter-repo
      - golang-go
      - neovim
      - nodejs
      - npm
    - require:
      - file: github_cli_repo
      - file: git_ppa
      - file: nvim_ppa
