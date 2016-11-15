" autocmd
" =======

au BufLeave   *__doc__*,help silent! call ReadMode(0)
au BufNewFile *__doc__*      silent! call ReadMode(1)
au FileType   help           silent! call ReadMode(1)

au BufNewFile *.sh,*.bash exe "normal! i#!/bin/bash\<CR>\<Esc>"
au BufNewFile *.html      exe "normal! i<!DOCTYPE html>\<CR>\<Esc>"
au BufNewFile *.node      exe "normal! i#!/usr/bin/env node\<CR>\<Esc>"
au BufNewFile *.py        exe "normal! i#!/usr/bin/env python\<CR>\<Esc>"
au BufNewFile *.pl        exe "normal! i#!/usr/bin/env perl\<CR>\<Esc>x"

au BufRead *.ipynb        setlocal ft=json
au BufRead *.tmux*        setlocal ft=sh
au BufRead,BufNewFile
      \ /usr/local/etc/nginx/*,/usr/local/nginx/conf/*,/etc/nginx/*
      \ setlocal ft=nginx

au FileType   css,html,jinja,json,sh,sql,tex,typescript,vim
      \ setlocal ts=2 sw=2 sts=2

au FileType rst,tex
      \ setlocal spell spelllang=en_us colorcolumn=80

au FileType tex
      \ nnoremap <leader>c :DoQuietly echo >> /tmp/_listener<CR>

au FileType   man         setlocal so=0
au FileType   vim         setlocal keywordprg=:help

au FileType   jinja       setlocal commentstring=<!--%s-->
au FileType   nginx       setlocal commentstring=#\ %s
au FileType   sql         setlocal commentstring=--%s
