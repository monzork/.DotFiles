# .DotFiles

Personal dotfiles for Arch/Hyprland and Ubuntu. `install.sh` symlinks
tracked files into place; nothing here is copied, so **editing a file in this
repo edits the live config**.

## Verify before you claim something works

```sh
./scripts/check.sh
```

Parse-checks every Lua file, runs `stylua --check`, `bash -n`s the shell
scripts, and boots Neovim headless failing on any startup output. Run it after
touching anything under `nvim/` — a config change is not verified until this
passes. It restores `nvim/lazy-lock.json` afterwards, so it never dirties the
tree.

## Layout

| path                 | what it is                                              |
| -------------------- | ------------------------------------------------------- |
| `nvim/`              | Neovim config, symlinked to `~/.config/nvim`            |
| `claude/`            | Claude Code config, symlinked file-by-file into `~/.claude` |
| `scripts/`           | verification + Claude hooks                             |
| `claude-account.zsh` | switches `CLAUDE_CONFIG_DIR` per project tree           |
| `.zshrc`, `.p10k.zsh`| **non-HyDE machines only** — see below                  |

## The shell layer is conditional

On **Arch + Hyprland this machine runs HyDE**, which sets
`ZDOTDIR=~/.config/zsh` in `~/.zshenv` and ships its own `.zshrc`, prompt and
zinit plugin setup. There, `~/.zshrc` is never read and this repo's `.zshrc` /
`.p10k.zsh` are inert. `install.sh` detects this (`is_hyde`) and:

- **HyDE:** skips oh-my-zsh/p10k entirely; drops fragments into
  `~/.config/zsh/conf.d/`, which is the *only* directory HyDE's `.zshenv`
  sources. A file placed at `~/.config/zsh/foo.zsh` is silently never loaded.
- **Everything else:** installs oh-my-zsh + powerlevel10k and links `~/.zshrc`,
  `~/.p10k.zsh`, with fragments in `~/.config/zsh/`.

Do not add dotfiles to `install.sh` with a glob. The symlink list is explicit
because `.claude/` here is *this repo's* project config and must never be
linked over `~/.claude`.

## Neovim

Load order: `init.lua` → `lua/monzork/{remap,set,lazy}.lua` → plugins → `after/plugin/*.lua`.

- `lua/monzork/lazy.lua` — plugin specs only (lazy.nvim). Inline `opts` here.
- `after/plugin/<plugin>.lua` — per-plugin setup and keymaps.
- `nvim/stylua.toml` — 4 spaces, 120 cols. It sits in `nvim/`, not the repo
  root, because stylua's upward search from `~/.config/nvim/...` only finds it
  inside the symlinked directory. conform.nvim formats Lua on save with it.
- Never hand-edit `nvim/lazy-lock.json`; use `:Lazy update`.

### Gotchas that have already bitten this config

- **`after/plugin/` runs last and silently wins.** A keymap set in
  `lua/monzork/remap.lua` is overwritten by the same key in `after/plugin/`.
  This is how `<leader><leader>` (source) was dead — leader is Space, so it is
  the same chord as telescope's `<leader><space>`.
- **Prefix collisions cost 300ms.** `timeoutlen=300`, so a mapping that is a
  strict prefix of another one stalls on every press. `<leader>t` vs
  `<leader>th` and `<leader>s` vs `<leader>s{h,g,d}` were both live; they are
  now `<leader>tt` and `<leader>sr`.
- **mason-lspconfig is v2.** `handlers` and `automatic_installation` were
  removed and are *silently ignored* if passed. Per-server settings go through
  `vim.lsp.config(name, {...})`; `automatic_enable` (default on) handles
  `vim.lsp.enable()`. Do not reintroduce `require("lspconfig")[name].setup()`.
- **Do not set LSP `capabilities` by hand.** blink.cmp registers them on
  `vim.lsp.config['*']` from its own plugin file; every server inherits them.
- **Guard `VimEnter` autocmds.** The startup terminal tab checks `argc() == 0`
  and a non-empty `nvim_list_uis()` so it does not fire for `git commit`,
  `nvim <file>`, or headless runs — the last of which would break `check.sh`.

## Conventions

- Neovim is on 0.12; prefer current APIs (`vim.diagnostic.jump`,
  `gitsigns.nav_hunk`, `vim.lsp.config`) over the deprecated ones.
- Comments explain *why*, especially for the non-obvious constraints above.
- Commit messages carry no AI attribution trailer.
