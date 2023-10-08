# README

This repository contains all of my configuration files that I want to keep
when switching between host machines. It's not perfect yet as the repository
does not have all the files added yet but I'll keep on adding them when I
remember.

## Configurations

The configuration files configure different applications and tools. Here's a
list of these those configuration targets.

### Vim

```bash
.vim
└── autoload
    └── plug.vim
.vimrc
```

The Vim setup uses [vim-plug](https://github.com/junegunn/vim-plug) plugin
manager. My current machine includes a plugin directory in `~/.vim/plugged`
(as defined in `~/.vimrc`) but the plugins aren't added to this repository
because each entry in the directory is a submodule. The plugins can be
installed to the machine by calling `:PlugInstall` in Vim. 

#### Plugins

- [`morhetz/gruvbox`](https://github.com/morhetz/gruvbox)

### Gnome Terminal

```bash
.config/
└── gnome-terminal
    └── gnome-terminal-profiles.dconf
```

`gnome-terminal-profiles.dconf` includes Gnome Terminal profiles. It includes
a Gruvbox Dark profile created via [Gogh](https://github.com/Gogh-Co/Gogh).

The profiles have been exported with the following `dconf` command:

```bash
dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
```

When a new machine is set up, the profiles can also be loaded in with `dconf`:

```bash
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
```

### Bash

```bash
.bash_aliases
.bash_logout
.bashrc
.profile
``` 

### Tmux

```bash
.tmux.conf
```

Currently includes only one variable that sets the $TERM as `tmux-256color` for
shell prompt color support. Normally it would be `screen` which does not include
the color support.

## License

Feel free to use any of these files to your liking in your own machines. This
repository is licensed under The Unlicense. Read more from
[LICENSE](https://github.com/paatre/dotfiles/blob/main/LICENSE).

