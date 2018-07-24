#! /bin/sh

# install.sh
# expects dotfiles repo to be kept in ~/.git

# alias git files
ln -s ~/.git/gitconfig ~/.gitconfig
ln -s ~/.git/git-commit-template ~/.gitmessage

read -p "Github user.email and press [ENTER]: " -e inputemail
echo Your email is $inputemail

read -p "Github user.name and press [ENTER]: " -e inputname
echo Your name is $inputname

read -p "Github user.signingkey and press [ENTER]: " -e inputkey
echo Your signingkey is $inputkey

git config --global user.email $inputemail
git config --global user.name $inputname
git config --global user.signingkey $inputkey
