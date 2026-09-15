# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles with two layers: **GNU Stow** symlinks configs from here into `$HOME`, and **masterless Salt** provisions the machine that consumes them. There is no build, no lint suite and no test framework — verification is Salt dry-runs plus a disposable LXC container.

Because `$HOME` files are symlinks back into this repo, **editing a file here changes the live config immediately**. `~/.bashrc`, `~/.profile` and `~/.config/nvim/*` are all symlinks — no copy step, and no "deploy" needed to test an edit.

## Commands

```bash
./bootstrap.sh                   # install salt-minion, then apply the highstate
./bootstrap.sh --salt-only       # just install Salt (used by test.sh)

./salt-local.sh render <state>   # compiled state (state.show_sls), no root needed
./salt-local.sh test <state>     # dry run (test=True)
./salt-local.sh apply <state>    # apply one state
./salt-local.sh highstate        # same full set as bootstrap.sh

./test.sh                        # full bootstrap in a fresh LXC container
./test.sh installs.nvm           # single state in a fresh container — dry run
lxc exec setup-test-fresh -- bash

stow -R -t "$HOME" bash nvim     # re-link individual packages by hand
```

Use dotted leaf names with `salt-local.sh` and `test.sh` (`repos.docker`, `packages.containers`, `installs.nvm`, `system.dotfiles`).

For Neovim changes, `nvim --headless -c 'qa'` surfaces any config error, and Mason's binaries are reachable at `~/.local/share/nvim/mason/bin/<tool>` (e.g. `stylua --check`) — they are on Neovim's PATH, not the shell's.

## Salt layout

`salt/top.sls` applies only **`installs`** and **`system`**. Everything else is reached transitively through `include:`, which makes the dependency layering the real structure:

```
repos.keyrings  →  repos.*      (apt keyrings + sources)
                →  packages.*   (pkg.installed)
                →  installs.*   (upstream curl|sh installers)  +  system.*  (stow, docker, lxd, ptyxis)
```

Two consequences that are not visible from the directory tree:

- **The highstate reaches 24 of the 39 SLS files.** `packages.desktop`, `packages.cloud`, `packages.fonts` and the repos only they pull in (`chrome`, `mozilla`, `vscode`, `cappelikan_ppa`, `google_cloud`, `tailscale`, `ppas`) are **never applied by `bootstrap.sh`** — nothing reachable from `top.sls` includes them. Apply them by name when needed. Verify reachability with `salt-call ... state.show_highstate` rather than by reading includes.
- **`packages` and `repos` (the `init.sls` aggregates) are not usable as states.** `./salt-local.sh render packages` fails with `Detected conflicting IDs` — `packages/init.sls` defines `install_core_packages` as a `test.nop`, colliding with the real `pkg.installed` of the same ID in `packages/core.sls`. Always target leaf states.

### Root vs. user in states

`salt-call` runs under `sudo`, so anything touching the user's `$HOME` must go through the Jinja preamble used by `system/dotfiles.sls`, `installs/nvm.sls` and `installs/deno.sls`:

```jinja
{% set home = salt['environ.get']('SUDO_USER_HOME', '/root') %}
{% set user = salt['environ.get']('SUDO_USER') or salt['environ.get']('USER') or 'root' %}
```

`bootstrap.sh` exports `SUDO_USER_HOME=$HOME`, and `salt-local.sh` forwards `SUDO_USER_HOME`/`SUDO_USER` through `sudo --preserve-env`. A state that writes to `~` without `runas: {{ user }}` will write to `/root`.

### Idempotency

`cmd.run` states gate on `creates:` (see `installs/deno.sls`) — note that **`creates:` never upgrades**, it only skips. When a version bump has to re-run, gate on `unless:` with a version comparison instead; `installs/tree_sitter_cli.sls` is the worked example. Commit `5790db5` fixed a state that failed on every run after the first.

`system/dotfiles.sls` is the authoritative stow package list, and `file.absent`s Ubuntu's stock `~/.bashrc`, `~/.profile` etc. before `stow -R` so the symlinks can be created.

## Neovim config

Kickstart-derived. `init.lua` holds options, keymaps and the lazy.nvim bootstrap, then `{ import = "custom.plugins" }` auto-loads **every** file in `lua/custom/plugins/` — each returns one lazy spec, and there is no central plugin registry to update when adding a file.

- `lua/kickstart/plugins/*` are unreferenced leftovers; nothing requires them.
- **nvim-treesitter is on `branch = "main"`**, whose API is `require("nvim-treesitter").install()` / `.get_installed()`. The legacy `nvim-treesitter.configs` and `nvim-treesitter.parsers` modules do not exist on that branch, so any plugin calling them errors — this is why `telescope.nvim` is pinned to `master` rather than `0.1.x`.
- It also requires `tree-sitter-cli >= 0.26.1`, which Ubuntu does not ship; `installs/tree_sitter_cli.sls` installs it from npm (prebuilt binary) and purges the apt package.
- Formatting is conform.nvim with `format_on_save`. **StyLua defaults to tabs** and there is no `stylua.toml`, so Lua files are tab-indented despite `init.lua` setting `expandtab`. `lua/custom/plugins/lsp.lua` has known pre-existing StyLua drift (two hand-wrapped calls) — don't let a reformat of it ride along in an unrelated commit.

## Bash config

`bash/.profile` is 17 lines whose only job is sourcing `.bashrc` for login shells (ssh, `su -`, TTY) — bash does not read `.bashrc` itself in a login shell, and there is no `.bash_profile`. All PATH construction lives in one `PREPEND_PATHS` block in `bash/.bashrc`; don't add PATH entries to `.profile`.

Machine- or work-specific functions and aliases belong in **`~/.bash_work`**, which `.bashrc` sources if present and `.gitignore` excludes. That is the mechanism for keeping credentials-adjacent or employer-specific shell code out of version control.

Note that GNOME's Wayland session does not source `~/.profile`, so nothing in the shell config reaches GUI-launched apps; use `~/.config/environment.d/*.conf` for that.

## Git

- `git/.gitconfig` switches identity by directory via `includeIf "gitdir:"` — `~/Projects/paatre/**` and `~/Projects/knowit/**` pull in `.gitconfig-paatre` / `.gitconfig-knowit` on top of `.gitconfig-base`.
- `.git-blame-ignore-revs` tracks bulk-reformat commits; add to it after any whole-file reformat. It is not referenced from `.gitconfig`, so `git blame` ignores it unless `blame.ignoreRevsFile` is set locally.
- `vim/.vim/plugged/` contains 10 gitlink entries with no `.gitmodules` — stale artifacts of the old vim-plug setup, not working submodules.

## Conventions

- Prefer **atomic commits**: one concern each, rather than a single commit spanning unrelated cleanups. Work is often tracked as GitHub issues, so reference them with `Closes #N` / `Refs #N` — and use `Refs` when only part of an issue's scope is addressed.
- Do not co-author Claude in the commit.
