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
    httpie
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
    "NVM"
    "OH MY ZSH"
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
    "$HOME/.nvm"
    "$HOME/.oh-my-zsh"
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
    "https://github.com/creationix/nvm"
    "https://github.com/robbyrussell/oh-my-zsh"
)

REQUIRED_BACKUP=(
    aws
    mongorc.js
    bashrc
    vimrc
    zshrc
    gemrc
    gnupg
    ssh
    travis
    gitignore
    gitconfig
    vim
    git
    pip
    tmux
    zsh
)

REQUIRED_ARGS=(
    start
    copy
    install
    github
    backup
)

# TODO
# virtualenvwrapper -> https://bitbucket.org/dhellmann/virtualenvwrapper

help () {
    printf "\nUSAGE: boot.sh (start|copy|install|github|backup)\n"
}

check () {
    for (( i = 0; i < ${#REQUIRED_PROGRAM[@]}; ++i )); do
        PROGRAM=${REQUIRED_PROGRAM[i]}
        PATH=${REQUIRED_PROGRAM_PATH[i]}
        URL=${REQUIRED_PROGRAM_URL[i]}

        if [ -d $PATH ] || [ -f $PATH ]; then
            echo "$PROGRAM found!"
            continue
        fi

        printf "$PROGRAM was NOT found! Install, then re-run this script! You may download here:\n$URL\n\nOpen in browser? [y/n] "
        read response

        if [[ $response =~ ^[Yy]$ ]]; then
            open "$URL" # will open URL in browser on MacOS
        fi

        exit 1
    done
}

xcode () {
    if ! type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}" ; then
       #... isn't correctly installed
       echo "XCode and Command Line Tools needs to be installed first! Download in Mac App Store."
       exit 1
    fi
}

aws_configure () {
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

github () {
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

dot_copy () {
    for dot in "${REQUIRED_DOTS[@]}"; do
        if [ ! -d "$HOME/.${dot}" ]; then
            printf "Could not find '.${dot}'... cp ${dot} > ${HOME}? (y|n) "
            read response

            if [[ $response =~ ^[Yy]$ ]]; then
                cp -R -v $HOME_DIR/$dot test/.$dot
            else
                exit 1
            fi
        fi
    done
}

dot_configure () {
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

zsh_configure () {
    cd $PARENT_DIR

    repo="$(echo $1 | rev | cut -d/ -f1 | rev)"
    if [ ! -d "${PARENT_DIR}/${repo}" ]; then
        printf "could not find project! "
        git clone https://github.com/$1.git
    fi

    cd "$PARENT_DIR/$repo"
    cp themes/* $HOME/.oh-my-zsh/custom/themes
    rm -rfv "$PARENT_DIR/$repo"
    cd $HOME_DIR
}

brew_install () {
    printf "brew update and cleanup? (y|n) "
    read response

    if [[ $response =~ ^[Yy]$ ]]; then
        brew update
        brew cleanup
    fi

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

gnucore_install () {
    GNU_CORE=(
        # Install GNU core utilities (those that come with OS X are outdated)
        # use --with-default-names for gnu-sed, gnu-tar, gnu-indent
        # gnu-which, gnu-grep
        coreutils
        gnu-sed
        gnu-tar
        gnu-indent
        gnu-which
        gnu-grep
        # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
        findutils
        bash
    )

    brew install ${GNU_CORE[@]} --interactive
}

backup () {
    for file in "${REQUIRED_BACKUP[@]}"; do
        echo "Backing up ${HOME}/.${file} to ${HOME}/dotbak"
        mkdir -p ~/dotbak
        mv ~/.$file ~/dotbak/
    done
}

dependencies () {
    xcode
    check
    aws_configure
    github
}

start () {
    dependencies
    brew_install
    dot_copy
    dot_configure
    zsh_configure 'akinjide/fishy2'
}

copy () {
    dot_copy
    dot_configure
}

install () {
    check
    brew_install
}

main () {
    if [ "$ARG_COUNT" -ne 1 ]; then
        help
    else
        for arg in "${REQUIRED_ARGS[@]}"; do
            if [[ "${ARGS[0]}" == $arg ]]; then
                $arg
                printf "\n\nCOMPLETE!\n"
                exit 0
            fi
        done

        echo "Invalid Command!"
        help
    fi
}

main
