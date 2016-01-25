#!/bin/sh

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup | grep -v README); do

	ln -sv dotfiles/$file ${HOME}/.$file 2>/dev/null

done

source ${HOME}/.bashrc

rm -fr ${HOME}/.vim/bundle/*

cd ${HOME}/.vim/bundle/
if [ $(whoami) == "maneyko" ]; then
    action="submodule add"
else
    action="clone"
fi

declare -a plugins

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
    git $action https://github.com/$plugin
done

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
