" functions
" =====================================

if has('autocmd')
  au BufNewFile *.sh,*.bash execute "normal! i#!/bin/bash\<CR>\<Esc>"
  au BufNewFile *.py execute "normal! i#!/usr/bin/env python\<CR>\<Esc>"
  au BufNewFile *.js execute "normal! i#!/usr/bin/env node\<CR>\<Esc>"
  au BufRead *tmux.conf,*.tmux set ft=sh
  au BufLeave help silent! call ReadMode(0)
  au FileType help setlocal keywordprg=:help | silent! call ReadMode(1)
  au FileType man set so=0
  au FileType html,javascript set nowrap
  au FileType html,sh,vim setlocal ts=2 sw=2 sts=2 expandtab
  au FileType vim setlocal keywordprg=:help
endif

fun! FlyMode(flymode_togg)
  if a:flymode_togg==1
    silent! call ReadMode(0)
    silent! setlocal so=999
    " normal zz
    let g:flymode_togg=0
    echo "Fly Mode on"
  else
    silent! setlocal so=1
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
    silent! set timeout timeoutlen=0 ttimeoutlen=0
    silent! nnoremap <buffer> r :call ReadMode(0)<CR>
    silent! nnoremap <buffer> q :q<CR>
    silent! nnoremap <buffer> x :q!<CR>
    silent! nnoremap <buffer> j <C-e>L0:file<CR>
    silent! nnoremap <buffer> k <C-y>L0:file<CR>
    silent! nnoremap <buffer> d <C-d>L0:file<CR>
    silent! nnoremap <buffer> u <C-u>L0:file<CR>
    silent! nnoremap <buffer> o 5<C-e>L0:file<CR>
    silent! nnoremap <buffer> p 5<C-y>L0:file<CR>
    if @% == ''
      silent! set ft=sh
      silent! nnoremap <buffer> q :q!<CR>
    endif
    let g:readmode_togg=0
    echo "Read Mode on"
  else
    silent! set modifiable
    silent! set noreadonly
    silent! set timeout nottimeout timeoutlen=1000 ttimeoutlen=-1
    silent! nunmap <buffer> r
    silent! nunmap <buffer> q
    silent! nunmap <buffer> x
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! nunmap <buffer> u
    silent! nunmap <buffer> d
    silent! nunmap <buffer> o
    silent! nunmap <buffer> p
    silent! execute "normal! M"
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

