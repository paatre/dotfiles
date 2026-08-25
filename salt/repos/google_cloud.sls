include:
  - repos.keyrings

google_cloud_repo:
  cmd.run:
    - name: "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg"
    - creates: /usr/share/keyrings/cloud.google.gpg
    - require:
      - file: ensure_keyrings_dir
  file.managed:
    - name: /etc/apt/sources.list.d/google-cloud-sdk.list
    - contents: "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main"
    - require:
      - cmd: google_cloud_repo
