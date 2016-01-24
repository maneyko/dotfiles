
" vundle commands
" ===========================================================================
"
set nocompatible                " overwrite functionality of vi
filetype off                    " can't recognize filetype for vundle
set rtp+=~/.vim/bundle/Vundle.vim " put vundle in rtp so it can start
call vundle#begin()             " call vundle

" vundle manages itself
Plugin 'VundleVim/Vundle.vim'   " plugin manager

" Plugin 'vim-utils/vim-man'      " helps view man pages
Plugin 'ervandew/supertab'      " ????????????????????????
" Plugin 'davidhalter/jedi-vim' " python completeion
Plugin 'scrooloose/nerdtree'    " tree view of pwd
Plugin 'ctrlpvim/ctrlp.vim'     " searches for files relative to pwd
Plugin 'tpope/vim-commentary'   " help comment out lines (gc)
Plugin 'tpope/vim-repeat'       " repeat more with '.'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'     " surrounding actions
Plugin 'tpope/vim-unimpaired'   " functionality with ][
" Plugin 'henrik/vim-indexed-search' " shows number of matches when searching
" Plugin 'chriskempson/base16-vim' " colorschemes compatible with terminal
" Plugin 'flazz/vim-colorschemes' " big folder of colorshemes

call vundle#end()
filetype plugin indent on       " load plugin and indent features for filetype

