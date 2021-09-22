#/bin/sh

sudo apt install -y peco direnv tig python3-venv python3-dev python-pip
# pip2 install --user powerline-shell

git config --global user.name Y.Arimitsu
git config --global user.email yoshikazu_arimitsu@albert2005.co.jp

## Python3.6 venv
# python3 -m venv ~/.py36

## Node.js LTS
. ~/.nvm/nvm.sh
nvm install node --lts

echo '. ~/dotfiles/.bashrc' >> ~/.bashrc

cp -prf ~/dotfiles/.config ~
cp -prf ~/dotfiles/.emacs ~

# 
mkdir ~/bin

cd ~/bin

# install powerline-go
wget https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
mv powerline-go-linux-amd64 powerline-go
chmod +x powerline-go
