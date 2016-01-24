#!/bin/bash

declare -a plugins

plugins=(\
# searches for files relative to pwd
"ctrlpvim/ctrlp.vim" \
# tab completion
"ervandew/supertab" \
# pairs brackets, parens, etc.
"jiangmiao/auto-pairs" \
# tree view of pwd
"scrooloose/nerdtree" \
# easier commenting
"tpope/vim-commentary" \
# pathogen
"tpope/vim-pathogen" \
# repeat more with '.'
"tpope/vim-repeat" \
# surrounding motions
"tpope/vim-surround" \
# functionality for '[' and ']'
"tpope/vim-unimpaired" \
)

cd ${HOME}/.vim/bundle/

if [ $(whoami) == "maneyko" ]; then
    action="submodule add"
else
    action="clone"
fi

for plugin in "${plugins[@]}"; do
    git $action https://github.com/$plugin
done

