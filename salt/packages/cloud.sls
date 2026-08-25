include:
  - repos.google_cloud
  - repos.tailscale

install_cloud_packages:
  pkg.installed:
    - pkgs:
      - google-cloud-cli
      - tailscale
    - require:
      - file: google_cloud_repo
      - file: tailscale_repo
