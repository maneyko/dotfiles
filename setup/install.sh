#!/bin/sh

cd $HOME/dotfiles/

for file in $(ls | egrep -v 'README|setup'); do
	ln -sv dotfiles/$file $HOME/.$file 2>/dev/null
done

source $HOME/.bashrc

mkdir $HOME/.vim/macros/
cd $HOME/.vim/macros/
rm less.bat less.sh less.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.bat
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.sh
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.vim
chmod +x less.sh

cd $HOME/.vim/ftplugin/
rm man.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim

mkdir $HOME/.vim/bundle 2>/dev/null
rm -fr $HOME/.vim/bundle/*
cd $HOME/.vim/bundle

vim -c "PluginInstall" -c "q"

if [[ $(tmux -V) == *'1.'* ]]; then
    rm $HOME/local/bin/tmux 2>/dev/null
    ./tmux_local_install.sh
fi

