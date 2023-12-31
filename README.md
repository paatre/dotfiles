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
├── after
│   └── ftplugin
│       ├── markdown.vim
│       └── vim.vim
└── autoload
    └── plug.vim
.vimrc
```

Notice how we have `.vim/after/` directory which handles overriding of
ftplugins in the source code. Without the directory and its `ftplugin` files,
autoformatting wouldn't work because rules of the formatting is overriden, for
example, in the `/usr/share/vim82/ftplugin/vim.vim` file.

The Vim setup uses [vim-plug](https://github.com/junegunn/vim-plug) plugin
manager. My current machine includes a plugin directory in `~/.vim/plugged`
(as defined in `~/.vimrc`) but the plugins aren't added to this repository
because each entry in the directory is a submodule. The plugins can be
installed to the machine by calling `:PlugInstall` in Vim. 

#### Plugins

Plugins are set between `call plug#begin('~/.vim/plugged')` and `call
plug#end()` in  `.vimrc`.
 
- [`morhetz/gruvbox`](https://github.com/morhetz/gruvbox)
- [`vim-airline/vim-airline`](https://github.com/vim-airline/vim-airline)
- [`tpope/vim-fugitive`](https://github.com/tpope/vim-fugitive)
- [`junegunn/fzf.vim`](junegunn/fzf.vim)

##### Gruvbox

The Gruvbox plugin is a color theme for Vim.

Gruvbox is configured in a following way:

```bash
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
``` 

##### Airline

Airline is a statusline plugin.

The most important Airline configuration is this:

```bash
let g:airline_powerline_fonts = 1
```

The Airline plugin is using
[Powerline](https://github.com/powerline/powerline) fonts which make the
statusline look cool with pointy text containers etc.

What needs to be noticed is that for the Powerline fonts to actually work the
Powerline fonts need to installed first. This should be done via cloning the
[Powerline fonts repository](https://github.com/powerline/fonts) and running
the installation script `./install.sh`. After this, the font can be changed
from the Gnome Terminal preferences for the used profile. Depending on the
fonts and the computer, some fonts work better with the Powerline than others.

##### Fugitive

A Vim wrapper for Vim. Needed this one for getting helpful branch info from a
current directory if in a Git repository. No need for extra configuration at
the moment.

##### Fzf

Fzf.vim is a fuzzy file finder. This plugin works as a wrapper for the `fzf`
command-line tool.

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

Currently includes only one variable that sets the `$TERM` as `tmux-256color` for
shell prompt color support. Normally it would be `screen` which does not include
the color support.

## License

Feel free to use any of these files to your liking in your own machines. This
repository is licensed under The Unlicense. Read more from
[LICENSE](https://github.com/paatre/dotfiles/blob/main/LICENSE).

