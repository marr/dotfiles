From: https://github.com/justone/dotfiles/wiki/Full-Documentation

Adding new dotfiles to your repository can be a little tricky. Here are the commands that need to be run:

$ cp .vimrc .dotfiles
$ dfm install
$ dfm add .vimrc
$ dfm ci -m 'adding .vimrc'
