#!/bin/sh

cd $HOME/dotfiles/

for file in $(ls | grep -v setup | grep -v README); do

	ln -sv dotfiles/$file $HOME/.$file 2>/dev/null

done

source $HOME/.bashrc
mkdir $HOME/.vim/bundle 2>/dev/null

rm -fr $HOME/.vim/bundle/*
cd $HOME/.vim/bundle

plugins=(\
#
# searches for files relative to pwd
"ctrlpvim/ctrlp.vim" \
#
# tab completion
"ervandew/supertab" \
#
# pairs brackets, parens, etc.
"jiangmiao/auto-pairs" \
#
# tree view of pwd
"scrooloose/nerdtree" \
#
# easier commenting
"tpope/vim-commentary" \
#
# pathogen
"tpope/vim-pathogen" \
#
# repeat more with '.'
"tpope/vim-repeat" \
#
# surrounding motions
"tpope/vim-surround" \
#
# functionality for '[' and ']'
"tpope/vim-unimpaired" \
)

for plugin in "${plugins[@]}"; do
    git clone https://github.com/$plugin
done

mkdir $HOME/.vim/macros/ 2>/dev/null

cd $HOME/.vim/macros/
rm less.bat less.sh less.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.bat
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.sh
wget https://raw.githubusercontent.com/vim/vim/master/runtime/macros/less.vim
chmod +x less.sh

cd $HOME/.vim/ftplugin/
rm man.vim
wget https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim

cd $HOME/dotfiles/setup/
if [[ $(tmux -V) == *'1.'* ]]; then
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make
fi

