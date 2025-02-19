#/bin/sh

mkdir ~/bin

sudo apt-get update
sudo apt-get install -y peco direnv tig

# install powerline-go
cd ~/bin

wget https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
mv powerline-go-linux-amd64 powerline-go
chmod +x powerline-go

# install lazygit
# sudo add-apt-repository ppa:lazygit-team/release -y
# sudo apt-get update
# sudo apt-get install -y lazygit

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io


# install config
git config --global user.name Y.Arimitsu
git config --global user.email yarimit@gmail.com

echo '. ~/dotfiles/.bashrc' >> ~/.bashrc

cp -prf ~/dotfiles/.config ~
cp -prf ~/dotfiles/.emacs ~

