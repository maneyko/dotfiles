#!/bin/sh

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup); do

	ln -sv dotfiles/$file ${HOME}/.$file 2>/dev/null

done

cd ${HOME}/.vim/bundle/
rm -fr *
git clone https://github.com/VundleVim/Vundle.vim.git \
    ${HOME}/.vim/bundle/Vundle.vim

vim -c "PluginInstall" -c "q" -c "q"

source ${HOME}/.bashrc

mkdir ${HOME}/.vim/macros/
mkdir ${HOME}/.vim/ftplugin/
mkdir ${HOME}/.vim/syntax/

ln -s $VIMRUNTIME/macros/less.* ${HOME}/.vim/macros/
ln -s $VIMRUNTIME/ftplugin/man.vim ${HOME}/.vim/ftplugin/
ln -s $VIMRUNTIME/syntax/man.vim ${HOME}/.vim/syntax/
