# Neovim configuration

Originally derived from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
and since diverged. Deployed by the [dotfiles repo](../../..) it lives in: GNU Stow
symlinks `nvim/.config/nvim` to `~/.config/nvim`, so editing a file here changes the
live config with no deploy step.

## Layout

```
init.lua                      options, keymaps, lazy.nvim bootstrap
lua/custom/plugins/*.lua      one lazy.nvim spec per file, auto-imported
after/ftplugin/lua.lua        per-filetype overrides
stylua.toml                   tabs, two columns wide
lua/kickstart/health.lua      :checkhealth kickstart
lazy-lock.json               pinned plugin commits
```

`init.lua` ends with `{ import = "custom.plugins" }`, which loads **every** file in
`lua/custom/plugins/`. Adding a plugin means adding a file that returns a spec —
there is no central list to register it in.

## Language support

`mason-lspconfig` only installs and enables servers. Per-server settings are
registered with `vim.lsp.config()` in `lua/custom/plugins/lsp.lua`, merged over the
defaults `nvim-lspconfig` ships in its `lsp/` directory.

| Language | Server | Formatter |
| --- | --- | --- |
| Lua | `lua_ls` (+ `lazydev` for Neovim types) | `stylua` |
| Python | `pyright` types, `ruff` lint and imports | `ruff` |
| JS/TS | `ts_ls` | `prettierd` |
| HTML | `html`, `emmet_ls` | `prettierd` |
| CSS | `cssls` | `prettierd` |
| Django templates | `djlsp` (`htmldjango` only) | `djlint --profile=django` |
| Go | `gopls` | `goimports`, `gofumpt` |

Formatting runs on save through `conform.nvim`. Its spec loads on `BufWritePre` —
without that event the `format_on_save` autocmd is never registered.

Pyright and ruff deliberately give up what the other does better: pyright has
`disableOrganizeImports`, ruff has `hoverProvider` switched off.

## Requirements

- **Neovim from master** (`0.13.0-dev`), provisioned from the `neovim-ppa/unstable`
  PPA by `salt/repos/neovim_ppa.sls`. `init.lua` calls `vim.hl.hl_op()`, which does
  not exist before 0.13.
- **`tree-sitter-cli` >= 0.26.1** for the `main` branch of `nvim-treesitter`, which
  compiles parsers locally. Ubuntu ships an older one, so
  `salt/installs/tree_sitter_cli.sls` installs it from npm.
- **`fd` and `ripgrep`** for Telescope. Hidden files are searched, scoped by
  `~/.config/fd/ignore` — most of the dotfiles repo sits behind a `.config/` path
  component, which `fd` treats as hidden.
- **Node.js** for `prettierd` and `copilot.vim`; **Go** for `gopls` and the Go
  formatters.

Tool binaries come from Mason at `~/.local/share/nvim/mason/bin/`, which is on
Neovim's `PATH` but not the shell's.

## Projects whose dependencies live in a container

Language servers here run on the host, so they need the project's dependencies
on the host too. Nothing about this config is container-aware, and nothing needs
to be: install the dependencies locally and everything works unchanged.

**Node/TypeScript.** `ts_ls` reads `node_modules` and `tsconfig.json` from disk
and never runs the code, so the container is irrelevant to it — type information
is just `.d.ts` files, and the container's Node version, architecture and native
binaries do not matter. Run the install on the host:

```sh
npm install   # or pnpm / yarn, from the project's lockfile
```

Without `node_modules` present, every import reports `Cannot find module`. With
it, diagnostics are clean. A compose setup that keeps `node_modules` in an
anonymous volume helps here, since the host and container installs stay
independent.

**Python.** Activate the project's virtualenv before starting Neovim:

```sh
source .venv/bin/activate && nvim
```

pyright does **not** auto-detect `.venv`; without activation it reports
`Import "..." could not be resolved` for every third-party package. Activation
is also what `nvim-coverage` needs to run `coverage json`, and what
`neotest-python` needs to find its runner, so it is one habit covering three
tools.

**When this is not enough.** Dependencies that cannot build on the host, or a
private registry reachable only from the container, would mean running the
server inside the container instead — `cmd = { "docker", "exec", "-i", ... }`.
That works only if the bind mount puts the source at the *same absolute path* on
both sides, because the server reports container paths and Neovim expects host
ones, and there is no URI translation here. Check with:

```sh
docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' <container>
```

`djlsp` is the exception that handles this itself: it takes
`--docker-compose-file` and `--docker-compose-service` to introspect a Django
project inside a running service while the server itself runs on the host.

## Notes

- `telescope.nvim` tracks `master`, not `0.1.x`. The `0.1.x` branch calls
  `nvim-treesitter.parsers`, which the `main` branch of nvim-treesitter removed.
- Commenting uses Neovim's built-in `gc`/`gcc` rather than a plugin.
- gruvbox runs with `transparent_mode`, so `Normal` has no background; nvim-notify
  is told to fade against `#282828` explicitly.
- `:checkhealth` should be clean apart from unused language providers and luarocks,
  both left as-is deliberately.
