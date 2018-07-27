# dot

This repository is personalized for my own usage, but you can use them however you'd like.

## Installation:

``` bash
$ git clone git@github.com:akinjide/dot.git ~/.dot
```


### pip dotfiles.

Commands below assume you already have [`pip`](https://pip.pypa.io/en/stable/) installed on your operating system
and [PyPI](https://pypi.python.org/pypi).

``` bash
$ cp ~/.dot/pip ~/.pip
$ ln -s ~/.pip/pypirc ~/.pypirc
$ cd ~/.pip

$ vim ~/.pypirc
# replace username and add password
# username = akinjide
# password = <replace-with-password>
```


### git dotfiles.

Commands below assume you already have [`git`](https://git-scm.com/downloads) installed on your operating system.

#### ssh

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

#### commandline

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

### zsh dotfiles.

Commands below assume you already have

  - [`zsh`](http://www.zsh.org/)
  - [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  - [rbenv](https://github.com/rbenv/rbenv)
  - [autoenv](https://github.com/kennethreitz/autoenv)
  - [vim](https://github.com/akinjide/dot-vim)
  - [node](https://nodejs.org/en/)
  - [nvm](https://github.com/creationix/nvm)
  - [pip](https://pypi.python.org/pypi/pip)
  - [tmux](https://github.com/akinjide/dot-tmux)
  - [brew](http://brew.sh/)
  - [git](https://github.com/akinjide/dot-git)
  - [virtualenvwrapper](https://bitbucket.org/dhellmann/virtualenvwrapper)

installed on your operating system.

``` bash
$ cp ~/.dot/zsh ~/.zsh
$ ln -s ~/.zsh/zshrc ~/.zshrc
```

#### environment variables

For Mac(OS):
```
$ vim ~/.zshrc (open zshrc file)
```

paste your config variable with their corresponding values in `~/.zsh/env` file

_Like so_

```
export sendgridKey=VALUE
export secretJwt=VALUE
```

Run `source ~/.zshrc` or `zr` if you've setup ZSH alias to reload
