# Switch Claude Code's config/auth dir based on which project tree you're in.
_claude_account_dir() {
  case "$PWD" in
    "$HOME/code/personal"*)   export CLAUDE_CONFIG_DIR="$HOME/.claude-personal" ;;
    "$HOME/code/phonecheck"*) export CLAUDE_CONFIG_DIR="$HOME/.claude-phonecheck" ;;
    *) unset CLAUDE_CONFIG_DIR ;;
  esac
}
chpwd_functions+=(_claude_account_dir)
_claude_account_dir
