" functions
" =====================================

if has('autocmd')
  au BufRead *tmux.conf set ft=sh
  au BufRead plugins.txt set ft=sh
  au BufNewFile *.sh execute "normal i#!/bin/sh\<CR>\<Esc>"
  au FileType c{,pp} source $HOME/.vim/ftplugin/c.vim
  au FileType help setlocal keywordprg=:help |
  \                     silent! call ReadMode(1)
  au FileType man set so=0
  au FileType python imap <Tab> <C-Space>
  au FileType sh source $HOME/.vim/ftplugin/sh.vim
  au FileType vim setlocal ts=2 sw=2 sts=2 expandtab keywordprg=:help
  au BufNewFile main.c{,pp} execute
        \"normal oint\<Space>main()\<CR>{\<CR>\<CR>}\<Up>\<Tab>
        \return\<Space>0;\<Esc>0"
endif
au BufNewFile,BufRead *_T_tmp* set ft=python

fun! FlyMode(flymode_togg)
  if a:flymode_togg==1
    silent! call ReadMode(0)
    silent! setlocal so=999
    silent! nnoremap <buffer> q :q<CR>
    let g:flymode_togg=0
    echo "Fly Mode on"
  else
    silent! setlocal so=5
    silent! nunmap <buffer> q
    let g:flymode_togg=1
    echo "Fly Mode off"
  endif
endfun
let g:flymode_togg=1

fun! ReadMode(readmode_togg)
  if a:readmode_togg==1
    silent! call FlyMode(0)
    silent! set nomodifiable
    silent! set readonly
    silent! set nolist
    silent! nnoremap <buffer> q :q<CR>
    silent! nnoremap <buffer> <leader>q :q!<CR>
    silent! nnoremap <buffer> j <C-e>L0:file<CR>
    silent! nnoremap <buffer> k <C-y>L0:file<CR>
    silent! nnoremap <buffer> i 5<C-e>L0:file<CR>
    silent! nnoremap <buffer> o 5<C-y>L0:file<CR>
    if @% == ''
      silent! set ft=sh
      silent! nnoremap <buffer> q :q!<CR>
    endif
    let g:readmode_togg=0
    echo "Read Mode on"
  else
    silent! set modifiable
    silent! set noreadonly
    silent! nunmap <buffer> q
    silent! nunmap <buffer> <leader>q
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! nunmap <buffer> i
    silent! nunmap <buffer> o
    silent! execute "normal M"
    let g:readmode_togg=1
    echo "Read Mode off"
  endif
endfun
let g:readmode_togg=1

fun! TabFun(tb, expd)
  execute "set tabstop="     . &l:tabstop
  execute "set softtabstop=" . &l:softtabstop
  execute "set shiftwidth="  . &l:shiftwidth
  set noexpandtab
  %retab!
  if a:expd==1
    set expandtab
    echo "expandtab"
  else
    set noexpandtab
    echo "noexpandtab"
  endif
  execute "set tabstop="     . a:tb
  execute "set softtabstop=" . a:tb
  execute "set shiftwidth="  . a:tb
  %retab!
endfun

" fun! PluginInstall()
"   !mkdir $HOME/dot/vim/bundle 2>/dev/null; echo;
"   \ for plugin in $(cat $HOME/dot/vim/src/plugins.txt |
"   \                 grep -Eo '^[^ \#]*'); do
"   \   if [ -d $HOME/dot/vim/bundle/${plugin\#*/} ]; then
"   \     cd $HOME/dot/vim/bundle/${plugin\#*/} && git pull --all -v;
"   \   else
"   \     cd $HOME/dot/vim/bundle && git clone https://github.com/$plugin;
"   \   fi; echo;
"   \ done;
"   \
"   \ for dir in $(ls $HOME/dot/vim/bundle); do
"   \   if [ \! "$(cat $HOME/dot/vim/src/plugins.txt |\
"                 \grep -Eo '^[^ \#]*' | grep $dir)" ]; then
"   \     echo removing directory, $dir/;
"   \     rm -fr $HOME/dot/vim/bundle/$dir;
"   \   fi;
"   \ done
" endfun
" command! PluginInstall silent call PluginInstall() |
"                      \ silent execute '!sleep 3' | redraw!
