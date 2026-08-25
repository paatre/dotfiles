install_ollama:
  cmd.run:
    - name: "curl -fsSL https://ollama.com/install.sh | sh"
    - creates: /usr/local/bin/ollama
    - success_retcodes:
      - 0
      - 1
    - timeout: 600
