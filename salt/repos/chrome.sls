include:
  - repos.keyrings

chrome_repo:
  cmd.run:
    - name: "curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg"
    - creates: /usr/share/keyrings/google-chrome.gpg
    - require:
      - file: ensure_keyrings_dir
  file.managed:
    - name: /etc/apt/sources.list.d/google-chrome.list
    - contents: "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main"
    - require:
      - cmd: chrome_repo
