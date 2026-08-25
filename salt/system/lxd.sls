lxd_bridge_firewall_fix:
  file.managed:
    - name: /etc/NetworkManager/dispatcher.d/lxd-bridge-fix
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - contents: |
        #!/bin/sh

        IFACE=$1
        ACTION=$2

        if [ "$IFACE" = "lxdbr0" ] && [ "$ACTION" = "up" ]; then
            if ! nft list chain ip filter FORWARD | grep -q 'oifname "lxdbr0" accept'; then
                nft insert rule ip filter FORWARD oifname "lxdbr0" accept
            fi

            if ! nft list chain ip filter FORWARD | grep -q 'iifname "lxdbr0" accept'; then
                nft insert rule ip filter FORWARD iifname "lxdbr0" accept
            fi
        fi
