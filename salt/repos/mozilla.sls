include:
  - repos.keyrings

mozilla_key:
  cmd.run:
    - name: "curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | gpg --dearmor -o /etc/apt/keyrings/packages.mozilla.org.gpg"
    - creates: /etc/apt/keyrings/packages.mozilla.org.gpg
    - require:
      - file: ensure_keyrings_dir

mozilla_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/mozilla.list
    - contents: "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main"
    - require:
      - cmd: mozilla_key
