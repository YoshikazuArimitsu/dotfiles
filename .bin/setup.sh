#/bin/sh

sudo apt install -y peco direnv tig

git config --global user.name Y.Arimitsu
git config --global user.email yoshikazu_arimitsu@albert2005.co.jp

echo '. ~/dotfiles/.bashrc' >> ~/.bashrc

cp -prf ~/dotfiles/.config ~
cp -prf ~/dotfiles/.emacs ~

mkdir ~/bin
cd ~/bin

# install powerline-go
wget https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
mv powerline-go-linux-amd64 powerline-go
chmod +x powerline-go
