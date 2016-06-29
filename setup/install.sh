#!/bin/bash

cd ~/

mv ~/dotfiles/ ~/.dotfiles/ || exit 1

files="\
.dotfiles/bash/
.dotfiles/bin/
.dotfiles/config/
.dotfiles/tmux/
.dotfiles/vim/
.bash/bashrc
.bash/bash_profile
.bash/inputrc
.tmux/tmux.conf
.vim/vimrc
"

mkdir .dotfiles/backup/
for f in $files; do
  ln -s $f . || \
    (mv .`basename $f` ~/dotfiles/backup/`basename $f` && ln -s $f .)
done

if [[ "$1" != +(-p|--plugins) ]]; then
  vim +PluginInstall
fi

