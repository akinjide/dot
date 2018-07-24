# dot

This repository is personalized for my own usage, but you can use them however you'd like.

## Installation

``` bash
$ git clone git@github.com:akinjide/dot.git ~/.dot
```

#### pip dotfiles.

The below commands will download the project, and setup [pip](https://pip.pypa.io/en/stable/) and [PyPI](https://pypi.python.org/pypi).

**NOTE**: 
- These instructions assume you already have [`pip`](https://pip.pypa.io/en/stable/) installed on your operating system.

``` bash
$ cp ~/.dot/pip ~/.pip
$ ln -s ~/.pip/pypirc ~/.pypirc
$ cd ~/.pip

$ vim pypirc
# replace username and add password
# username = akinjide
# password = <replace-with-password>
```


#### git dotfiles.

The below commands will download the project, and setup [git](https://git-scm.com/downloads).

**NOTE**:
- I use [`git`](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git) ZSH plugin, for aliases.
- These instructions assume you already have [`git`](https://git-scm.com/downloads) installed on your operating system.

##### ssh

``` bash
$ cp ~/.dot/git ~/.git
$ ln -s ~/.git/gitconfig ~/.gitconfig
$ ln -s ~/.git/gitignore ~/.gitignore
$ ln -s ~/.git/git-commit-template ~/.gitmessage
$ git config --global user.email "r@akinjide.me"
$ git config --global user.name "Akinjide Bankole"
$ git config --global user.signingkey E41877A3EA43D3
$ git config --global core.excludesfile ~/.gitignore
```

##### commandline

``` bash
$ cp ~/.dot/git ~/.git
$ cd ~/.git
$ chmod +x install.sh
$ ./install.sh
```

If it still won't work, you can run the script like this:

``` bash
$ sudo install.sh
```

