#!/bin/sh

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup | grep -v README); do

	ln -sv dotfiles/$file ${HOME}/.$file 2>/dev/null

done

cd ${HOME}/.vim/bundle/

rm -fr *

# source ${HOME}/dotfiles/vim/setup/plugin_install.sh

source ${HOME}/.bashrc

mkdir ${HOME}/.vim/macros/ 2>/dev/null
mkdir ${HOME}/.vim/ftplugin/ 2>/dev/null

cd ${HOME}/.vim/macros/
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.bat
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.sh
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.vim

chmod +x less.sh

cd ${HOME}/.vim/ftplugin/
wget https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim
