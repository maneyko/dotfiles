#!/bin/sh

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup | grep -v README); do

	ln -sv dotfiles/$file ${HOME}/.$file 2>/dev/null

done

source ${HOME}/.bashrc

rm -fr ${HOME}/.vim/bundle/*
source ${HOME}/dotfiles/setup/plugin_install.sh

mkdir ${HOME}/.vim/macros/ 2>/dev/null
mkdir ${HOME}/.vim/ftplugin/ 2>/dev/null

cd ${HOME}/.vim/macros/
rm less.bat less.sh less.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.bat
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.sh
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.vim
chmod +x less.sh

cd ${HOME}/.vim/ftplugin/
rm man.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim
