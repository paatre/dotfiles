{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}

configure_ptyxis:
  cmd.run:
    - name: |
        gsettings set org.gnome.Ptyxis font-name 'Cascadia Mono NF 12'
        gsettings set org.gnome.Ptyxis use-system-font false
        gsettings set org.gnome.Ptyxis audible-bell false
        DEFAULT_UUID=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ custom-command 'tmux'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ label 'Default'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ opacity 0.92
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ palette 'Gruvbox'
        gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_UUID/ use-custom-command true
    - runas: {{ user }}
