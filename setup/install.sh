#!/bin/bash

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup); do

	ln -sv dotfiles/$file ${HOME}/.$file 2>/dev/null

done

cd ${HOME}/.vim/bundle/
rm -fr *
git clone https://github.com/VundleVim/Vundle.vim.git \
    ${HOME}/.vim/bundle/Vundle.vim
vim -c "PluginInstall"
