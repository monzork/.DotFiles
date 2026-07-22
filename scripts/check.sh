#!/usr/bin/env bash
# Verification loop for this repo: parse-check the Lua, check formatting, then
# boot Neovim headless and fail on any startup error.
#
# This exists so config changes can be *verified* rather than eyeballed --
# including changes made by an agent that cannot open an editor.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

step() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
fail() { printf '\033[31mFAIL\033[0m %s\n' "$1"; status=1; }
ok()   { printf '\033[32mok\033[0m   %s\n' "$1"; }

# Prefer the Mason-managed stylua, fall back to one on PATH.
stylua_bin="$HOME/.local/share/nvim/mason/bin/stylua"
command -v stylua >/dev/null 2>&1 && stylua_bin="$(command -v stylua)"

mapfile -t lua_files < <(find "$repo/nvim" -type f -name '*.lua' | sort)

step "Lua syntax (${#lua_files[@]} files)"
if nvim --clean -l "$repo/scripts/lua-syntax.lua" "${lua_files[@]}"; then
    ok "all files parse"
else
    fail "Lua parse errors"
fi

step "Formatting (stylua)"
if [[ -x "$stylua_bin" ]]; then
    if "$stylua_bin" --check "$repo/nvim"; then
        ok "formatting clean"
    else
        fail "run '$stylua_bin $repo/nvim' to fix"
    fi
else
    printf 'skip (stylua not installed; :MasonInstall stylua)\n'
fi

step "Shell syntax"
while IFS= read -r script; do
    if bash -n "$script" 2>/dev/null; then
        ok "$(basename "$script")"
    else
        bash -n "$script" || true
        fail "$script"
    fi
done < <(find "$repo" -maxdepth 2 -type f -name '*.sh' -not -path '*/.git/*' | sort)

step "Neovim headless startup"
# Booting lets lazy.nvim install/update plugins, which rewrites lazy-lock.json.
# Snapshot and restore it so verifying never dirties the tree -- lockfile bumps
# should come from a deliberate `:Lazy update`, not from running the checks.
lock="$repo/nvim/lazy-lock.json"
lock_backup="$(mktemp)"
trap 'rm -f "$lock_backup"' EXIT
[[ -f "$lock" ]] && cp "$lock" "$lock_backup"

# Errors during startup go to stderr; a clean boot prints nothing.
startup_err="$(nvim --headless -c 'qall' 2>&1 || true)"

if [[ -f "$lock" ]] && ! cmp -s "$lock" "$lock_backup"; then
    cp "$lock_backup" "$lock"
    printf 'note: restored lazy-lock.json (startup updated plugins)\n'
fi

# First boot on a new machine legitimately prints progress while lazy.nvim
# installs plugins and nvim-treesitter downloads parsers. Drop that chatter so
# the check stays meaningful instead of failing on every fresh clone.
startup_err="$(printf '%s\n' "$startup_err" |
    grep -Ev '^\[nvim-treesitter/' |
    grep -Ev '^\[lazy\.nvim\]' |
    grep -Ev '^[[:space:]]*$' || true)"

if [[ -n "$startup_err" ]]; then
    printf '%s\n' "$startup_err"
    fail "startup produced errors"
else
    ok "clean boot"
fi

printf '\n'
[[ $status -eq 0 ]] && printf '\033[32mAll checks passed.\033[0m\n' || printf '\033[31mChecks failed.\033[0m\n'
exit $status
