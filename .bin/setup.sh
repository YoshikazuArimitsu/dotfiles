#/bin/sh

mkdir ~/bin

sudo apt install -y peco direnv tig

# install powerline-go
cd ~/bin

wget https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
mv powerline-go-linux-amd64 powerline-go
chmod +x powerline-go

# install lazygit
sudo add-apt-repository ppa:lazygit-team/release -y
sudo apt install -y lazygit

# install config
git config --global user.name Y.Arimitsu
git config --global user.email yoshikazu_arimitsu@albert2005.co.jp

echo '. ~/dotfiles/.bashrc' >> ~/.bashrc

cp -prf ~/dotfiles/.config ~
cp -prf ~/dotfiles/.emacs ~

