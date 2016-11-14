" functions
" =========

if has('autocmd')
  au BufLeave   *__doc__*,help silent! call ReadMode(0)

  au BufNewFile *.sh,*.bash exe "normal! i#!/bin/bash\<CR>\<Esc>"

  au BufNewFile *__doc__*   silent! call ReadMode(1)
  au BufNewFile *.html      exe "normal! i<!DOCTYPE html>\<CR>\<Esc>"
  au BufNewFile *.node      exe "normal! i#!/usr/bin/env node\<CR>\<Esc>"
  au BufNewFile *.py        exe "normal! i#!/usr/bin/env python\<CR>\<Esc>"
  au BufNewFile *.pl        exe "normal! i#!/usr/bin/env perl\<CR>\<Esc>x"

  au BufRead    *.tmux*     setlocal ft=sh
  au BufRead    *.ipynb     setlocal ft=json
  au BufRead,BufNewFile /usr/local/etc/nginx/*,/usr/local/nginx/conf/*,/etc/nginx/* setlocal ft=nginx

  au FileType   help        silent! call ReadMode(1)
  au FileType   html,css    setlocal keywordprg=:help |
  au FileType   nginx       setlocal commentstring=#\ %s
  au FileType   css,html,jinja,json,sh,sql,tex,typescript,vim setlocal ts=2 sw=2 sts=2 expandtab
  au FileType   man         setlocal so=0
  au FileType   vim         setlocal keywordprg=:help
  au FileType   tex         nnoremap <leader>c :DoQuietly echo >> /tmp/_listener<CR>
  au FileType   rst,tex     setlocal spell spelllang=en_us |
  au FileType   rst,tex     setlocal colorcolumn=80
  au FileType   jinja       setlocal commentstring=<!--%s-->
  au FileType   sql         setlocal commentstring=--%s
endif

fun! ReadMode(readmode_togg)
  if a:readmode_togg==1
    silent! call FlyMode(0)
    silent! setlocal nomodifiable
    silent! setlocal readonly
    silent! setlocal nolist
    silent! setlocal timeout timeoutlen=0 ttimeoutlen=0
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
      silent! nnoremap <buffer> q :q!<CR>
    endif
    let g:readmode_togg=0
    echo 'Read Mode on'
  else
    silent! setlocal modifiable
    silent! setlocal noreadonly
    silent! setlocal timeout nottimeout timeoutlen=1000 ttimeoutlen=-1
    silent! nunmap <buffer> r
    silent! nunmap <buffer> q
    silent! nunmap <buffer> x
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! nunmap <buffer> u
    silent! nunmap <buffer> d
    silent! nunmap <buffer> o
    silent! nunmap <buffer> p
    silent! execute 'normal! M'
    let g:readmode_togg=1
    echo 'Read Mode off'
  endif
endfun
let g:readmode_togg=1

fun! FlyMode(flymode_togg)
  if a:flymode_togg==1
    silent! call ReadMode(0)
    silent! setlocal so=999
    " normal zz
    let g:flymode_togg=0
    echo 'Fly Mode on'
  else
    silent! setlocal so=1
    let g:flymode_togg=1
    echo 'Fly Mode off'
  endif
endfun
let g:flymode_togg=1

fun! TabFun(tb, expd)
  execute 'setlocal tabstop='     . &l:tabstop
  execute 'setlocal softtabstop=' . &l:softtabstop
  execute 'setlocal shiftwidth='  . &l:shiftwidth
  setlocal noexpandtab
  %retab!
  if a:expd==1
    setlocal expandtab
    echo 'expandtab'
  else
    setlocal noexpandtab
    echo 'noexpandtab'
  endif
  execute 'setlocal tabstop='     . a:tb
  execute 'setlocal softtabstop=' . a:tb
  execute 'setlocal shiftwidth='  . a:tb
  %retab!
endfun
