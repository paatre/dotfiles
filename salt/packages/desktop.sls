include:
  - repos.chrome
  - repos.mozilla
  - repos.vscode
  - repos.ppas

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
      - pkgrepo: cappelikan_ppa
