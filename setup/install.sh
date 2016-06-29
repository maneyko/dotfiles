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
  link=".`basename $f`" # Note the dot in front of `basename`
  ln -s $f $link || \
    (mv $link ~/dotfiles/backup/ && ln -s $f $link)
done

if [[ "$1" != +(-p|--plugins) ]]; then
  git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
  vim +PluginInstall
fi

