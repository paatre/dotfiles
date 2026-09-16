# README

This repository contains my personal configuration files (dotfiles), organized and managed using [GNU Stow](https://www.gnu.org/software/stow/). This setup allows for flexible and selective deployment of configurations across different machines by symlinking files from this repository into my home directory.

It also includes an automated bootstrapping mechanism using [Salt](https://saltproject.io/) and an isolated testing environment using [LXC](https://linuxcontainers.org/).

## Purpose

The primary goal of this repository is to:
* Provide a centralized and version-controlled backup of my most important configuration files.
* Enable quick and easy setup of my preferred development environment on new systems using an automated Salt bootstrap script.
* Maintain a clear separation between my tracked dotfiles and application-specific caches or plugins.
* Safely test configuration changes in fresh, disposable LXC containers before applying them to my main system.

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

## Bootstrapping with Salt

To automate the initial setup of a new machine, you can use the included `bootstrap.sh` script. This script installs the Salt Minion in masterless mode and applies the states defined in the `salt/` directory to configure the system.

```bash
cd ~/dotfiles
./bootstrap.sh
```

To work on one Salt state at a time, use `salt-local.sh` from the repository root:

```bash
./salt-local.sh render repos
./salt-local.sh test repos
./salt-local.sh apply repos
./salt-local.sh highstate
```

`render` shows the compiled Salt state, `test` runs Salt's dry-run mode, `apply` applies a single state, and `highstate` applies the same full state set as `bootstrap.sh`.

The Salt states are split into smaller modules, so individual pieces can be checked directly:

```bash
./salt-local.sh test repos.docker
./salt-local.sh test packages.containers
./salt-local.sh test installs.nvm
./salt-local.sh test system.dotfiles
```

## Trying out Ansible

Ansible is being evaluated alongside Salt; both configure the same machine, and
Salt remains the one `bootstrap.sh` runs. The playbook lives in `ansible/`, with
one task file per Salt directory.

```bash
sudo apt install ansible

./ansible-local.sh list            # every task and its tags
./ansible-local.sh check           # dry run with diffs, changes nothing
./ansible-local.sh apply           # apply everything
```

Tags mirror the Salt state names, so a single piece can be targeted the same way:

```bash
./ansible-local.sh check keyboard
./ansible-local.sh apply installs
./ansible-local.sh check repos,packages
```

Tasks that touch the system escalate with `become`, so a sudo password is asked
for unless sudo is already cached. Tags that only configure the user's desktop
or home directory need no privileges at all, and `--no-pass` skips the prompt
for those:

```bash
./ansible-local.sh check keyboard --no-pass
```

`become` runs through `/usr/bin/sudo.ws`, the classic sudo Ubuntu still ships
alongside sudo-rs. sudo-rs wraps the prompt that `sudo -p` asks for, which
ansible-core 2.20.1 does not recognise, so become times out without ever sending
the password. The setting can go once ansible-core carries the fix for it.

Two differences from the Salt states are deliberate:

* `ansible/site.yml` lists every group explicitly, so it also applies the
  `desktop`, `cloud` and `fonts` packages that Salt's highstate never reaches.
* Desktop settings use the `dconf` module rather than shelling out to
  `gsettings`, which reports changes accurately and needs no session bus
  handling, because the play already runs as the user.

## Testing with LXC

Before deploying changes to your host machine, you can test the bootstrapping process in an isolated LXC container using `test.sh`. This spins up a fresh Ubuntu container, copies the dotfiles, and runs the bootstrap script inside it.

```bash
./test.sh
```

Pass a Salt state name to test a single state in a fresh container. Targeted state tests are dry-runs by default:

```bash
./test.sh repos
./test.sh installs.nvm
./test.sh system.dotfiles
```

Once the test completes, you can inspect the container:
```bash
lxc exec setup-test-fresh -- bash
```

## Manual Usage with Stow

If you prefer to deploy specific configuration packages manually without running the full Salt bootstrap, simply navigate to the root of this repository and run `stow <package_name>`. For example:

```bash
cd ~/dotfiles
stow bash
stow vim
stow gnome-terminal
```

## License

Feel free to use any of these files to your liking in your own machines. This repository is licensed under The Unlicense. Read more from LICENSE.
