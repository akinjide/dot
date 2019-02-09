#!/bin/bash

# global vars
ARG_COUNT=$#
ARGS=$@
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # script dir relative path
PARENT_DIR="$(dirname "$HOME_DIR")"

SAVED_CHOICE=""

REQUIRED_DOTS=(
    git
    pip
    tmux
    vim
    zsh
    ssh
)

REQUIRED_GIT_REPOS=(
    https://github.com/akinjide/akinjide-www
    https://github.com/akinjide/akinjide-resume
)

REQUIRED_BREW=(
    ack
    cmatrix
    cowsay
    gnu-typist
    gnupg
    go
    heroku
    hugo
    ncdu
    nmap
    node
    pacman4console
    postgresql
    redis
    tig
    tree
    typespeed
    unrar
    wget
    youtube-dl
    zsh-syntax-highlighting
)

REQUIRED_PROGRAM=(
    "HOMEBREW"
    "NODEJS"
    "PYTHON"
    "RUBY"
    "GO"
    "GIT"
    "ZSH"
    "VIM"
    "TMUX"
    "PIP"
    "AWS CLI"
)

REQUIRED_PROGRAM_PATH=(
    "/usr/local/bin/brew"
    "/usr/local/bin/node"
    "/usr/local/bin/python"
    "/usr/bin/ruby"
    "/usr/local/bin/go"
    "/usr/bin/git"
    "/bin/zsh"
    "/usr/bin/vim"
    "/usr/local/bin/tmux"
    "/usr/local/bin/pip"
    "/usr/local/bin/aws"
)

REQUIRED_PROGRAM_URL=(
    "https://brew.sh"
    "https://nodejs.org/dist/v8.11.3/node-v8.11.3.pkg"
    "https://www.python.org/downloads/release/python-2715/"
    "https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz"
    "golang"
    "https://git-scm.com/downloads"
    "http://zsh.sourceforge.net"
    "http://www.vim.org"
    "https://tmux.github.io/"
    "https://pip.pypa.io/en/stable/installing/"
    "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
)

# TODO
# virtualenvwrapper -> https://bitbucket.org/dhellmann/virtualenvwrapper
# add installation of oh_my_zsh theme fishy2. https://github.com/akinjide/fishy2

# sub-routines
function help {
    printf "\nUSAGE: boot.sh (start|copy|install|github)\n"
}

function check {
    for (( i = 0; i < ${#REQUIRED_PROGRAM[@]}; ++i )); do
        PROGRAM=${REQUIRED_PROGRAM[i]}
        PATH=${REQUIRED_PROGRAM_PATH[i]}
        URL=${REQUIRED_PROGRAM_URL[i]}

        if [ ! -f $PATH ]; then
            printf "$PROGRAM was NOT found! You may download here:\n$URL\n\nOpen in browser? [y/n] "
            read response

            if [[ $response =~ ^[Yy]$ ]]; then
                open "$URL" # will open URL in browser on MacOS
            fi

            exit 1
        fi

        echo "$PROGRAM found!"
    done
}

function xcode {
    if ! type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}" ; then
       #... isn't correctly installed
       echo "XCode and Command Line Tools needs to be installed first! Download in Mac App Store."
       exit 1
    fi
}

function check_oh_my_zsh {
    URL="https://github.com/robbyrussell/oh-my-zsh"

    cd ~
    if [ ! -d ".oh-my-zsh" ]; then
        printf "Could NOT find oh_my_zsh! You may download here:\n${URL}\n\nOpen in browser? [y/n] "
        read response

        if [[ $response =~ ^[Yy]$ ]]; then
            open "${URL}" # will open URL in browser on MacOS
        else
            exit 1
        fi
    fi

    echo "oh_my_zsh found!"
    cd $HOME_DIR
}

function check_nvm {
    URL="https://github.com/creationix/nvm"
    PATH="/usr/local/bin/tmux"

    cd ~
    if [ ! -d ".nvm" ]; then
        printf "Could NOT find nvm! You may download here:\n${URL}\n\nOpen in browser? [y/n] "
        read response

        if [[ $response =~ ^[Yy]$ ]]; then
            open "${URL}" # will open URL in browser on MacOS
        else
            exit 1
        fi
    fi

    echo "nvm found!"
    cd $HOME_DIR
}

function check_aws_configure {
    cd ~

    if [ ! -d ".aws" ]; then
        printf "Could NOT find AWS credentials! Run AWS Configure Utility? (y/n) "
        read response

        if [[ $response =~ ^[Yy]$ ]]; then
            aws configure
        else
            exit 1
        fi
    fi

    cd $HOME_DIR
}

function check_repos {
    cd $PARENT_DIR

    for repo in "${REQUIRED_GIT_REPOS[@]}"; do
        REPO_NAME="$(echo ${repo} | rev | cut -d/ -f1 | rev)"

        if [ ! -d "${PARENT_DIR}/${REPO_NAME}" ]; then
            printf "Could not find project '${REPO_NAME}'... git clone project? (ssh|https|cancel) "
            read response

            if [[ $response == "ssh" ]]; then
                git clone git@github.com:akinjide/${REPO_NAME}.git
            elif [[ $response == "https" ]]; then
                git clone $repo
            else
                exit 1
            fi
        fi
    done

    cd $HOME_DIR
}

function dot_copy {
    for dot in "${REQUIRED_DOTS[@]}"; do
        if [ ! -d "$HOME/.${dot}" ]; then
            printf "Could not find '.${dot}'... cp ${dot} -> ${HOME}? (y|n) "
            read response

            if [[ $response =~ ^[Yy]$ ]]; then
                cp -R -v $HOME_DIR/$dot test/.$dot
            else
                exit 1
            fi
        fi
    done
}

function dot_configure {
    for dot in "${REQUIRED_DOTS[@]}"; do
        if [ ! -d "$HOME/.${dot}" ]; then
            echo "Could NOT find .${dot}! Run ./boot.sh copy"
            exit 1
        fi
    done

    chmod +x install.sh
    ./install.sh

    cd $HOME_DIR
}

function brew_install {
    for pkg in "${REQUIRED_BREW[@]}"; do
        response=""
        if [ -z $SAVED_CHOICE ]; then
            printf "brew info or install? (info|install) "
            read response
        else
            printf "\n"
            response=$SAVED_CHOICE
        fi

        if [[ $response == "info" ]]; then
            SAVED_CHOICE="info"
            brew info $pkg
        elif [[ $response == "install" ]]; then
            SAVED_CHOICE="install"
            brew install $pkg
        else
            exit 1
        fi
    done
}

function dependencies {
    xcode
    check
    check_oh_my_zsh
    check_nvm
    check_docker
    check_aws_configure
    check_repos
}


function complete_exit {
   printf "\n\nCOMPLETE!\n"
   exit 0
}

function main {
    if [ "$ARG_COUNT" -ne 1 ]; then
        help
    else
        if [ "${ARGS[0]}" == "start" ]; then
            dependencies
            brew_install
            dot_copy
            dot_configure
            complete_exit
        elif [ "${ARGS[0]}" == "copy" ]; then
            dot_copy
            dot_configure
            complete_exit
        elif [ "${ARGS[0]}" == "install" ]; then
            check
            brew_install
            complete_exit
        elif [ "${ARGS[0]}" == "github" ]; then
            check_repos
            complete_exit
        else
            echo "Invalid Command!"
            help
        fi
    fi
}

main
