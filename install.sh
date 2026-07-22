#!/bin/bash
declare -A os=( ["ubuntu"]="apt" ["fedora"]="dnf" ["arch"]="pacman" )
echo "Select os ubuntu/fedora/arch"
read currentOS
currentOS="${currentOS,,}"
if [[ -z "${os[$currentOS]:-}" ]]
then
  echo "Unknown OS '$currentOS' — expected one of: ${!os[*]}"
  exit 1
fi
if [[ "$currentOS" = "arch" ]]
then
  sudo pacman -Sy --needed --noconfirm git curl zsh wget gnupg base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
else
  sudo ${os[$currentOS]} install git curl zsh wget gpg
fi
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cd ~
git clone git@github.com:monzork/.DotFiles.git
cd .DotFiles
# Read all files inside .DotFiles and use it as array
files_array=$(ls -A | grep "^\." | grep -v ".git")

cd ~
for file_name in $files_array
do
  ln -sf .DotFiles/$file_name $file_name
done

mkdir -p ~/.config/zsh
ln -sf ~/.DotFiles/claude-account.zsh ~/.config/zsh/claude-account.zsh
ln -sf ~/.DotFiles/nvim ~/.config/nvim

# Neovim (latest release, matches the path already in .zshrc)
mkdir -p ~/.local/opt
rm -rf ~/.local/opt/nvim-linux-x86_64
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
tar -C ~/.local/opt -xzf /tmp/nvim.tar.gz
rm /tmp/nvim.tar.gz

# NVM (latest release; .zshrc already sources $HOME/.nvm/nvm.sh)
nvm_latest=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_latest}/install.sh" | bash

# Visual Studio Code instalation
echo $currentOS
if [[ $currentOS = "ubuntu" ]]
then
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt install apt-transport-https
  sudo apt update
  sudo apt install code

  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
  sudo apt-get install gnupg -y
  wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
  echo "deb [ arch=amd64,arm64  ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
  sudo apt-get update -y
  sudo apt-get install -y mongodb-org

fi

if [[ "$currentOS" = "fedora" ]]
then
  sudo ${os[$currentOS]} upgrade --refresh -y
  sudo ${os[$currentOS]} install dnf-plugins-core -y
  sudo ${os[$currentOS]} install snapd -y
  sudo snap install corelist
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  dnf check-update
  sudo dnf install code
fi

if [[ "$currentOS" = "arch" ]]
then
  sudo pacman -S --noconfirm docker docker-compose
  sudo systemctl enable --now docker
fi

if command -v snap >/dev/null 2>&1
then
  sudo snap install discord
else
  echo "snap not available, skipping discord install"
fi

# Redis Stack (includes RedisJSON) via docker instead of a native install
if command -v docker >/dev/null 2>&1
then
  sudo docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
else
  echo "docker not available, skipping redis-stack container"
fi

