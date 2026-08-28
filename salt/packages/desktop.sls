include:
  - repos.chrome
  - repos.mozilla
  - repos.vscode
  - repos.cappelikan_ppa

install_desktop_packages:
  pkg.installed:
    - pkgs:
      - code
      - firefox
      - firefox-nightly
      - flameshot
      - gnome-tweaks
      - google-chrome-stable
    - require:
      - file: chrome_repo
      - file: mozilla_repo
      - file: vscode_repo
      - file: cappelikan_ppa
