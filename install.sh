#!/bin/bash
declare -A os=( ["ubuntu"]="apt" ["fedora"]="dnf" )
echo "Select os ubuntu/fedora"
read currentOS
currentOS="${currentOS,,}"
sudo ${os[$currentOS]} install git curl zsh wget gpg
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cd ~
git clone git@github.com:monzork/.DotFiles.git
cd .DotFiles
# Read all files inside .DotFiles and use it as array
files_array=$(ls -A | grep "^\." | grep -v ".git")

for file_name in $files_array
do
  ln -s .DotFiles/$file_name $file_name
done

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
  echo "deb [ arch=amd64,arm64  ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
  sudo apt-get update -y
  sudo apt-get install -y mongodb-org

fi

if "$currentOS" = "fedora"
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

sudo snap install discord

