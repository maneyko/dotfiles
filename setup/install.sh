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

mkdir ${HOME}/.vim/macros/ 2>/dev/null
mkdir ${HOME}/.vim/ftplugin/ 2>/dev/null
mkdir ${HOME}/.vim/syntax/ 2>/dev/null

cd ${HOME}/.vim/macros/
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.bat
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.sh
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.vim
