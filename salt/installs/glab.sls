download_glab:
  cmd.run:
    - name: |
        rm -f /tmp/glab.deb
        GLAB_VER=$(curl -s "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases" | grep -Po '"tag_name":"v\K[^"]*' | head -n 1)
        if [ -z "$GLAB_VER" ]; then
          echo "Failed to fetch GLAB version from GitLab API"
        fi
        curl -sSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VER}/downloads/glab_${GLAB_VER}_linux_amd64.deb" -o /tmp/glab.deb
    - unless: test -f /usr/bin/glab

install_glab:
  pkg.installed:
    - sources:
      - glab: /tmp/glab.deb
    - require:
      - cmd: download_glab
