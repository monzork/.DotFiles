# Tracked Claude Code configuration

`install.sh` symlinks these into `~/.claude/`:

| repo file       | linked to                  |
| --------------- | -------------------------- |
| `settings.json` | `~/.claude/settings.json`  |
| `CLAUDE.md`     | `~/.claude/CLAUDE.md`      |

Only individual files are linked, never the directory. `~/.claude/` also holds
`.credentials.json`, session state, shell snapshots and installed plugins —
none of which belong in a git repo.

Because these are symlinks, changing a setting from inside Claude Code (`/model`,
`/config`) writes straight through into this repo and shows up as a normal diff.

Per-account switching lives in `../claude-account.zsh`, which points
`CLAUDE_CONFIG_DIR` at a separate directory per project tree. Note that those
alternate config dirs are *not* covered by the symlinks above.
