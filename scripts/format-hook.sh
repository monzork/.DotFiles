#!/usr/bin/env bash
# Claude Code PostToolUse hook: run stylua over any .lua file just written.
# Keeps agent edits formatted identically to format-on-save in the editor,
# so the two never fight over the same lines.
set -euo pipefail

file_path="$(jq -r '.tool_input.file_path // empty')"
[[ -n "$file_path" && "$file_path" == *.lua && -f "$file_path" ]] || exit 0

stylua_bin="$HOME/.local/share/nvim/mason/bin/stylua"
command -v stylua >/dev/null 2>&1 && stylua_bin="$(command -v stylua)"
[[ -x "$stylua_bin" ]] || exit 0

"$stylua_bin" "$file_path" >/dev/null 2>&1 || true
