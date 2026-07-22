# .DotFiles

Personal config for Arch/Hyprland, Ubuntu and Fedora.

```sh
git clone git@github.com:monzork/.DotFiles.git ~/.DotFiles
~/.DotFiles/install.sh          # prompts for ubuntu/fedora/arch
~/.DotFiles/scripts/check.sh    # verify the Neovim config boots clean
```

`install.sh` is re-runnable: it skips work already done and backs up anything
real it would replace (`<file>.bak.<timestamp>`).

## zsh

The shell layer depends on the machine:

- **Arch + Hyprland (HyDE):** HyDE owns zsh. It sets `ZDOTDIR=~/.config/zsh`
  in `~/.zshenv` and ships its own `.zshrc`, prompt and zinit plugin setup, so
  `~/.zshrc` is never read and this repo's `.zshrc` / `.p10k.zsh` are unused.
  `install.sh` detects this and only drops fragments into
  `~/.config/zsh/conf.d/` — the one directory HyDE actually sources.
- **Everything else:** `install.sh` installs oh-my-zsh +
  [PowerLevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh) and links
  `~/.zshrc` and `~/.p10k.zsh` from here.

[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
is installed after powerlevel10k on non-HyDE machines.

## nvim

Symlinked to `~/.config/nvim` by `install.sh`, so edits here are live.
lazy.nvim manages plugins; `scripts/check.sh` verifies a change before you
trust it. See [CLAUDE.md](CLAUDE.md) for the layout and the gotchas.

## Claude Code

Installed by `install.sh` (`npm i -g @anthropic-ai/claude-code`). Config is
tracked in [`claude/`](claude/) and symlinked file-by-file into `~/.claude`.
`claude-account.zsh` switches `CLAUDE_CONFIG_DIR` per project tree.

## Redis Stack (JSON capable)

Installed by `install.sh` as a docker container (`redis/redis-stack`, includes
RedisJSON) when docker is available.
[redis-stack](https://redis.io/docs/getting-started/install-stack/docker/)

## NVM / node

`install.sh` installs NVM, the current LTS node, `pm2` and Claude Code.
[NVM](https://github.com/nvm-sh/nvm)

If `pm2` reports `ENOSPC` on Linux, raise the file-watcher limit:
[ENOSPC](https://klequis.io/error-enospc-system-limit-for-number-of-file-watchers-reached/)

## Desktop apps

Discord and DBeaver CE everywhere, plus:

- **Ubuntu:** Slack and Teams. Microsoft discontinued the official Teams client
  for Linux, so this installs the `teams-for-linux` community wrapper.
- **Arch / Fedora:** Postman (`postman-bin` via yay on Arch, snap on Fedora).

Everything tracks upstream latest: snap channels default to stable/latest, Arch
repos and the AUR are rolling, and Neovim/NVM are pulled from their newest
GitHub release. The one deliberate exception is node — `install.sh` uses
`nvm install --lts` rather than the absolute newest, because `pm2` and other
global tooling regularly lag behind current.
