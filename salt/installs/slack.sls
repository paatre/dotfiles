install_slack:
  cmd.run:
    - name: |
        VERSION="4.47.69"
        URL="https://downloads.slack-edge.com/desktop-releases/linux/x64/${VERSION}/slack-desktop-${VERSION}-amd64.deb"
        curl -sL "$URL" -o /tmp/slack.deb
        apt-get update && apt-get install -y /tmp/slack.deb
    - unless: test -f /usr/bin/slack
