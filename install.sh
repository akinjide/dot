#! /bin/sh

# install.sh
# expects dotfiles repo to be kept in ~

# GIT
# alias git files
ln -s ~/.git/gitconfig ~/.gitconfig
ln -s ~/.git/gitignore ~/.gitignore
ln -s ~/.git/git-commit-template ~/.gitmessage

read -p "Github user.email and press [ENTER]: " -e GITHUB_EMAIL
echo Your email is $GITHUB_EMAIL

read -p "Github user.name and press [ENTER]: " -e GITHUB_NAME
echo Your name is $GITHUB_NAME

read -p "Github user.signingkey and press [ENTER]: " -e SIGNING_KEY
echo Your signingkey is $SIGNING_KEY

git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_NAME
git config --global user.signingkey $SIGNING_KEY
git config --global core.excludesfile ~/.gitignore

# PIP
# alias pip files
ln -s ~/.pip/pypirc ~/.pypirc
ln -s ~/.pip/pip.conf ~/.pip.conf

# Securing the .pypirc file
chmod 600 ~/.pypirc

# Edit the .pypirc username and password
read -p "PYPI username and press [ENTER]: " -e PYPI_USERNAME
read -p "PYPI password and press [ENTER]: " -e PYPI_PASSWORD

echo "$(cat ~/.pypirc)" | sed "s/username = .*/username = $PYPI_USERNAME/g; s/password = .*/password = $PYPI_PASSWORD/g" | tee ~/.pypirc

# TMUX
# alias tmux files
ln -s ~/.tmux/tmux.conf ~/.pip.conf

# ZSH
# alias zsh files
ln -s ~/.zsh/zshrc ~/.zshrc

# VIM
# alias vim files
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim
git submodule init
git submodule update
vim +PluginInstall +qall
