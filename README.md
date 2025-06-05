# README

This repository contains my personal configuration files (dotfiles), organized and managed using [GNU Stow](https://www.gnu.org/software/stow/). This setup allows for flexible and selective deployment of configurations across different machines by symlinking files from this repository into my home directory.

## Purpose

The primary goal of this repository is to:
* Provide a centralized and version-controlled backup of my most important configuration files.
* Enable quick and easy setup of my preferred development environment on new systems.
* Maintain a clear separation between my tracked dotfiles and application-specific caches or plugins.

## Configuration Targets

This repository includes configurations for a variety of applications and tools, generally organized into individual Stow "packages" (directories). These cover areas such as:

* **Shells:** Bash
* **Terminal Emulators:** Gnome Terminal
* **Text Editors:** Vim, Neovim
* **Version Control:** Git
* **Terminal Multiplexers:** Tmux
* **System Utilities:** `bpytop`, `fd`, `fzf`, `starship`
* **Miscellaneous:** General scripts, Ubuntu-specific settings, custom data files.

### Plugin Management (Vim/Neovim)

For editors like Vim and Neovim, plugins are managed by their respective plugin managers (e.g., `vim-plug` for Vim, `lazy.nvim` for Neovim) and are **not tracked** within this Git repository. This keeps the dotfiles clean and focused solely on personal configuration. Plugins can be installed by running the appropriate command (e.g., `:PlugInstall` in Vim) after the main configuration is stowed.

## Usage with Stow

To deploy a configuration package, simply navigate to the root of this repository (`~/dotfiles/`) and run `stow <package_name>`. For example:

```bash
cd ~/dotfiles
stow bash
stow vim
stow gnome-terminal
# ...and so on for other packages you wish to deploy.
```

## License

Feel free to use any of these files to your liking in your own machines. This repository is licensed under The Unlicense. Read more from LICENSE.
