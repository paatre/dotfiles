include:
  - repos.github_cli
  - repos.ppas

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
      - pkgrepo: git_ppa
      - pkgrepo: nvim_ppa
