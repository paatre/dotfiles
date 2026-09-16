{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

# Keyboard settings that should be identical on every machine. Deliberately
# narrow: window and workspace bindings are left at GNOME's defaults, and
# edge-tiling plus toggle-tiled-left/right belong to the Tiling Assistant
# extension, which records their original values to restore on disable.
#
# `gsettings set` writes through the dconf service on the session bus. Without
# it the write is discarded with only a warning, and the command still exits 0,
# so the bus is passed explicitly and its absence is made a hard failure rather
# than a silent no-op.
configure_keyboard:
  cmd.run:
    - name: |
        BUS="/run/user/$(id -u)/bus"
        if [ ! -S "$BUS" ]; then
            echo "No D-Bus session at $BUS for $(id -un)." >&2
            echo "gsettings cannot commit without one: log into the desktop and re-run." >&2
            exit 1
        fi
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$BUS"

        # Which key opens the Activities overview. GNOME defaults to 'Super',
        # meaning either key; pinning the left one keeps it consistent across
        # laptop keyboards and whatever an external keyboard sends.
        gsettings set org.gnome.mutter overlay-key "'Super_L'"

        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi')]"
        gsettings set org.gnome.desktop.input-sources show-all-sources false
    - runas: {{ user }}
