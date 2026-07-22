#!/usr/bin/env bash
# Bootstrap a fresh machine from this repo.
#
# Safe to re-run: every step either skips work that is already done or backs up
# what it replaces.
set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[1m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[33mwarn\033[0m %s\n' "$1"; }

# Symlink $1 -> $2, backing up anything real that is already there. Never
# clobbers a directory in place, which the old `ls -A | grep "^\."` loop did
# (it would have linked this repo's project-scoped .claude over ~/.claude).
link() {
    local src="$1" dest="$2"
    if [[ ! -e "$src" ]]; then
        warn "skip $dest (missing source $src)"
        return
    fi
    if [[ -L "$dest" ]]; then
        rm -f "$dest"
    elif [[ -e "$dest" ]]; then
        mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"
        warn "backed up existing $dest"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    printf '  %s -> %s\n' "$dest" "$src"
}

declare -A os=(["ubuntu"]="apt" ["arch"]="pacman")
echo "Select os ubuntu/arch"
read -r currentOS
currentOS="${currentOS,,}"
if [[ -z "${os[$currentOS]:-}" ]]; then
    echo "Unknown OS '$currentOS' — expected one of: ${!os[*]}"
    exit 1
fi

# HyDE (the Arch + Hyprland desktop config) owns the whole zsh layer: it sets
# ZDOTDIR=~/.config/zsh in ~/.zshenv and ships its own .zshrc, prompt and zinit
# plugin setup. On those machines this repo's .zshrc / .p10k.zsh are dead files
# -- zsh never reads ~/.zshrc at all -- so we leave the shell to HyDE and only
# drop our own fragments into its conf.d/. Everywhere else we own the shell.
is_hyde() {
    [[ "$currentOS" == "arch" ]] || return 1
    { command -v hyprctl >/dev/null 2>&1 || [[ -d "$HOME/.config/hypr" ]]; } || return 1
    [[ -d "$HOME/.config/zsh/conf.d" ]] || return 1
}

info "Base packages"
if [[ "$currentOS" == "arch" ]]; then
    sudo pacman -Sy --needed --noconfirm git curl zsh wget gnupg base-devel jq
    if ! command -v yay >/dev/null 2>&1; then
        git clone https://aur.archlinux.org/yay.git /tmp/yay &&
            (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi
else
    sudo "${os[$currentOS]}" install -y git curl zsh wget gpg jq
fi

info "Cloning dotfiles"
if [[ ! -d "$HOME/.DotFiles" ]]; then
    git clone git@github.com:monzork/.DotFiles.git "$HOME/.DotFiles"
    DOTFILES="$HOME/.DotFiles"
else
    echo "  already present at $DOTFILES"
fi

if is_hyde; then
    info "Shell: HyDE detected (Arch + Hyprland) — leaving zsh config to HyDE"
    # HyDE's .zshenv sources ${ZDOTDIR}/conf.d/*.zsh. Anything dropped outside
    # conf.d/ is never read, which is why claude-account.zsh never loaded.
    link "$DOTFILES/claude-account.zsh" "$HOME/.config/zsh/conf.d/claude-account.zsh"
else
    info "Shell: installing oh-my-zsh + powerlevel10k"
    [[ -d "$HOME/.oh-my-zsh" ]] ||
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    [[ -d "$p10k_dir" ]] ||
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"

    link "$DOTFILES/.zshrc" "$HOME/.zshrc"
    link "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
    # This repo's .zshrc sources ~/.config/zsh/*.zsh.
    link "$DOTFILES/claude-account.zsh" "$HOME/.config/zsh/claude-account.zsh"
fi

info "Secrets (ansible-vault)"
if [[ "$currentOS" == "arch" ]]; then
    sudo pacman -S --needed --noconfirm ansible
else
    sudo apt-get install -y ansible
fi

# Decrypt this machine's copy of each vault-encrypted secret. Never symlinked
# -- a symlink would point at the encrypted blob in the repo, not plaintext.
decrypt_vault() {
    local src="$1" dest="$2"
    if [[ ! -e "$src" ]]; then
        warn "skip $dest (missing source $src)"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    if ansible-vault decrypt --vault-password-file "$vault_pass_file" --output "$dest" "$src" 2>/dev/null; then
        chmod 600 "$dest"
        printf '  %s -> %s\n' "$dest" "$src"
    else
        warn "failed to decrypt $src (wrong vault password?)"
    fi
}

if command -v ansible-vault >/dev/null 2>&1; then
    vault_pass_file="$(mktemp)"
    trap 'shred -u "$vault_pass_file" 2>/dev/null || rm -f "$vault_pass_file"' EXIT
    read -rs -p "Vault password (for keys/ and ssh/ secrets): " vault_pass
    echo
    printf '%s' "$vault_pass" >"$vault_pass_file"
    unset vault_pass

    decrypt_vault "$DOTFILES/ssh/encrypted_id_rsa" "$HOME/.ssh/id_rsa"
    decrypt_vault "$DOTFILES/ssh/encrypted_bastion-staging.pem" "$HOME/.ssh/bastion-staging.pem"
    if is_hyde; then
        decrypt_vault "$DOTFILES/keys/phonecheck.zsh" "$HOME/.config/zsh/conf.d/phonecheck.zsh"
    else
        decrypt_vault "$DOTFILES/keys/phonecheck.zsh" "$HOME/.config/zsh/phonecheck.zsh"
    fi

    rm -f "$vault_pass_file"
    trap - EXIT
else
    warn "ansible-vault unavailable, skipping secret decryption"
fi

link "$DOTFILES/ssh/config" "$HOME/.ssh/config"

info "Editor config"
# Explicit list. Do NOT glob dotfiles here: .claude/ is this repo's own
# project-scoped Claude config and must never be linked over ~/.claude.
link "$DOTFILES/.vimrc" "$HOME/.vimrc"
link "$DOTFILES/nvim" "$HOME/.config/nvim"

info "Claude Code config"
# Individual files only -- ~/.claude also holds credentials, session state and
# installed plugins, none of which belong in a git repo.
link "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

info "Neovim (latest release)"
mkdir -p "$HOME/.local/opt"
rm -rf "$HOME/.local/opt/nvim-linux-x86_64"
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz &&
    tar -C "$HOME/.local/opt" -xzf /tmp/nvim.tar.gz
rm -f /tmp/nvim.tar.gz

info "NVM + node tooling"
if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
    nvm_latest=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_latest}/install.sh" | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
if command -v nvm >/dev/null 2>&1; then
    nvm install --lts
    npm i -g pm2 @anthropic-ai/claude-code tree-sitter-cli
else
    warn "nvm unavailable, skipping node/pm2/claude-code/tree-sitter-cli"
fi

info "Neovim runtime deps (search tools, go, clipboard, build tools)"
# ripgrep/fd back telescope's live_grep and find_files; go builds gopls
# (mason installs it via `go install`); make+gcc build telescope-fzf-native
# and luasnip's jsregexp step; a clipboard tool backs `clipboard=unnamedplus`
# (set.lua) -- wl-clipboard under HyDE/Wayland, xclip as the X11 fallback.
if [[ "$currentOS" == "arch" ]]; then
    sudo pacman -S --needed --noconfirm ripgrep fd unzip go xclip
    is_hyde && sudo pacman -S --needed --noconfirm wl-clipboard
else
    sudo apt-get install -y ripgrep fd-find unzip golang-go xclip wl-clipboard build-essential
    # Debian/Ubuntu ship the fd binary as `fdfind` to avoid a name clash;
    # nvim-telescope and everything else expects `fd` on PATH.
    if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi
fi

info "Nerd Font (JetBrainsMono)"
# lua/monzork/set.lua sets have_nerd_font = true, which nvim-web-devicons and
# the diagnostic signs rely on for icon glyphs -- without an actual Nerd Font
# installed those render as boxes/question marks.
font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
if [[ ! -d "$font_dir" ]]; then
    mkdir -p "$font_dir"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -o /tmp/nerd-font.tar.xz &&
        tar -C "$font_dir" -xJf /tmp/nerd-font.tar.xz
    rm -f /tmp/nerd-font.tar.xz
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$font_dir"
else
    echo "  already present at $font_dir"
fi

# Visual Studio Code instalation
echo "$currentOS"
if [[ $currentOS == "ubuntu" ]]; then
    sudo apt-get install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >/tmp/packages.microsoft.gpg
    sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f /tmp/packages.microsoft.gpg
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code

    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

if [[ "$currentOS" == "arch" ]]; then
    sudo pacman -S --noconfirm docker docker-compose
    sudo systemctl enable --now docker
fi

info "Desktop apps"
if command -v snap >/dev/null 2>&1; then
    sudo snap install discord
else
    warn "snap not available, skipping discord"
fi

# DBeaver CE on every machine; Postman everywhere except Ubuntu, which gets
# Slack + Teams instead. Every source here tracks upstream latest: snap channels
# default to stable/latest, and Arch's repos and the AUR are rolling.
case "$currentOS" in
arch)
    sudo pacman -S --needed --noconfirm dbeaver
    if command -v yay >/dev/null 2>&1; then
        yay -S --noconfirm postman-bin
    else
        warn "yay not available, skipping postman"
    fi
    ;;
ubuntu)
    if command -v snap >/dev/null 2>&1; then
        # Microsoft discontinued the official Teams client for Linux;
        # teams-for-linux is the maintained community wrapper.
        sudo snap install teams-for-linux
        sudo snap install slack
        sudo snap install dbeaver-ce
    else
        warn "snap not available, skipping teams/slack/dbeaver"
    fi
    ;;
esac

# Redis Stack (includes RedisJSON) via docker instead of a native install
if command -v docker >/dev/null 2>&1; then
    if sudo docker ps -a --format '{{.Names}}' | grep -qx redis-stack; then
        echo "  redis-stack container already exists, skipping"
    else
        sudo docker run -d --name redis-stack --restart unless-stopped -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
    fi
else
    echo "docker not available, skipping redis-stack container"
fi

info "Done. Verify the Neovim config with: $DOTFILES/scripts/check.sh"
