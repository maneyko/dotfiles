" nvimrc
" ======
"
" table of contents
" -----------------
"   * plugins
"   * sets
"   * colors
"   * plugin options
"   * functions
"   * remaps
"   * auto commands

let g:minimal_vimrc = 0

" plugins
" -------
set nocompatible
filetype off

call plug#begin()
  " core
  Plug 'junegunn/vim-plug'
  Plug 'mkarmona/colorsbox'          " color scheme
  Plug 'alvan/vim-closetag'
  Plug 'jiangmiao/auto-pairs'        " completes pairs
  Plug 'tpope/vim-commentary'        " commenting motions
  Plug 'tpope/vim-endwise'           " closes functions (if and fi)
  Plug 'tpope/vim-repeat'            " '.' for plugins
  Plug 'tpope/vim-surround'          " surrounding motions
  Plug 'tpope/vim-unimpaired'        " bracket functions and more

  if minimal_vimrc == 0
    Plug 'phreax/vim-coffee-script'
    Plug 'vim-scripts/nginx.vim'       " nginx
    Plug 'digitaltoad/vim-pug'         " pug
    Plug 'gisphm/vim-gitignore'        " .gitignore files
    Plug 'tpope/vim-markdown'
    Plug 'martinda/Jenkinsfile-vim-syntax'
    " Plug 'mattn/emmet-vim'             " html completion
    Plug 'ctrlpvim/ctrlp.vim'          " fuzzy file finder
    Plug 'scrooloose/nerdtree'         " filetree
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'yegappan/mru'
    " Plug 'vim-python/python-syntax'
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'mileszs/ack.vim'

    Plug 'tpope/vim-fugitive'          " git integration
    Plug 'tpope/vim-rails'

    Plug 'chikamichi/mediawiki.vim'

    Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
  endif
call plug#end()

filetype plugin indent on

" sets
" ----
set autoindent
if has('patch-7.4-346')
  set breakindent
endif
set clipboard=unnamed
set encoding=UTF-8
set expandtab
set hlsearch
set ignorecase
set incsearch
set linebreak
set list
set listchars=tab:\ \ ,trail:⋅
if has('mouse')
  set mouse=a
  " set ttymouse=xterm2
endif
if version >= 702
  au InsertLeave * set list
  au InsertEnter * set nolist
endif
set number
set numberwidth=3
set ruler
set scrolloff=1
set shiftwidth=4
set showcmd
set smartcase
set smartindent
set smarttab
set softtabstop=4
set t_Co=256
set tabstop=4
set tildeop
set nowrap
set laststatus=0 ruler

let g:netrw_dirhistmax=0  " no .netrwhist files
set guicursor=

" colors
" ------
if !empty(glob($VIMRUNTIME . '/syntax/syntax.vim'))
  syntax on
endif
if isdirectory(glob('~/.config/nvim/plugged/colorsbox'))
  colorscheme colorsbox-stnight
endif

" make bg and fg colors same as terminal
highlight Normal ctermbg=NONE
highlight Normal ctermfg=NONE


" plugin options
" --------------
let g:user_emmet_leader_key = '<NUL>'  " equals '<C-space>,'
let g:do_refresh_key = '<C-M>'
" let g:SuperTabCrMapping = 1
" let g:SuperTabDefaultCompletionType = "<c-n>"
let g:vimpager = {}
let g:less = {}
let g:less.enabled = 0
let g:less.scrolloff = 5
let NERDTreeShowHidden=1
let g:NERDTreeIndicatorMapCustom = {
\ "Modified"  : "✹",
\ "Staged"    : "✚",
\ "Untracked" : "✭",
\ "Renamed"   : "➜",
\ "Unmerged"  : "═",
\ "Deleted"   : "✖",
\ "Dirty"     : "✗",
\ "Clean"     : "✔︎",
\ 'Ignored'   : '☒',
\ "Unknown"   : "?"
\ }
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" let NERDTreeMapOpenInTab='<ENTER>'

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
\ }
let g:ctrlp_regexp = 1
let g:markdown_fenced_languages = ['bash=sh', 'python', 'ruby', 'html']
let g:markdown_syntax_conceal = 0

let g:semshi#error_sign = 0
let g:semshi#mark_selected_nodes = 0
let g:semshi#excluded_hl_groups = ['local', 'unresolved']

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" let g:coc_global_extensions = ['coc-solargraph']

" functions
" ---------
fun! ReadMode(readmode_togg)
  " acts like ``less``
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
  " main function is setting so=999
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
  " retabs file
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

fun! AlignRow(tw_)
  for i in range(1, a:tw_)
    execute "normal! 080lF\<space>r\<cr>"
  endfor
endfun


" remaps
" ------
let g:mapleader = ','

nnoremap <C-h>            <C-w>h
nnoremap <C-j>            <C-w>j
nnoremap <C-k>            <C-w>k
nnoremap <C-l>            <C-w>l
nnoremap <C-w>h           :vertical resize -5<CR>
nnoremap <C-w>l           :vertical resize +5<CR>
nnoremap <C-i>            gT
nnoremap <C-o>            gt
nnoremap <C-b>            :nohl<CR><C-l>
nnoremap <C-n>            :set relativenumber!<CR>
nnoremap <leader><leader> :w<CR>
nnoremap <leader>f        :call FlyMode(flymode_togg)<CR>
nnoremap <leader>kq       :q!<CR>
nnoremap <leader>n        :NERDTreeToggle<CR>
nnoremap <leader>q        :q<CR>
nmap     <leader>r        <Plug>(coc-references)
nnoremap <leader>m        :MRU<CR>
nnoremap <leader>s        :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>kw       :w !sudo tee %<CR>
" nnoremap <space>          <C-d>
nnoremap \a               :<C-U>call AlignRow(v:count1)<CR>
nnoremap \e               :<C-U>call TabFun(v:count1*2,1)<CR>
nnoremap \n               :<C-U>call TabFun(v:count1*2,0)<CR>
nnoremap \r               :call ReadMode(readmode_togg)<CR>
nnoremap \s               1z=
nnoremap \w               :%s/\s\+$//<CR>:nohl<CR><C-l>
nnoremap Q                <Esc>
nnoremap K                :call CocActionAsync('jumpDefinition', 'tab drop')<CR>
nnoremap U                <C-r>
nnoremap Y                y$
nnoremap daf              :1,$d<CR>
nnoremap yaf              :1,$y<CR>
nnoremap zfs              :mkview<CR>
nnoremap zfl              :loadview<CR>


inoremap <C-a>            <C-o>^
inoremap <C-d>            <C-o>x
inoremap <C-e>            <C-o>$
inoremap <C-p>            <C-r>*
inoremap <C-w>            <C-o><C-w>
inoremap <M-b>            <C-o>dd
inoremap <M-f>            <C-o>w
inoremap jk               <Esc>

vnoremap .                :normal! .<CR>
vnoremap &                :normal! &<CR>

map <ScrollWheelUp>       <C-y>
map <2-ScrollWheelUp>     <C-y>
map <3-ScrollWheelUp>     <C-y>
map <4-ScrollWheelUp>     <C-y>
map <ScrollWheelDown>     <C-e>
map <2-ScrollWheelDown>   <C-e>
map <3-ScrollWheelDown>   <C-e>
map <4-ScrollWheelDown>   <C-e>


" auto commands
" -------------
" au BufLeave *__doc__*,help
"       \ silent! call ReadMode(0)
" au BufNewFile *__doc__*
"       \ silent! call ReadMode(1)
au BufNewFile *.sh,*.bash
      \ exe "normal! i#!/bin/bash\<CR>\<Esc>"
au BufNewFile *.rb
      \ exe "normal! iclass " .
      \ substitute(substitute(expand('%:t')[:-4], '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', "g"),'^.','\u&','')
      \ . "\<CR>\<CR>end\<Esc>ggj"
au BufNewFile *.node
      \ exe "normal! i#!/usr/bin/env node\<CR>\<Esc>"
au BufNewFile *.py
      \ exe "normal! i#!/usr/bin/env python\<CR>\<Esc>"
au BufNewFile *.pl
      \ exe "normal! i#!/usr/bin/env perl\<CR>\<Esc>x"
au BufNewFile *.html,*.php
      \ exe "normal!"
      \ . "i<!DOCTYPE html>\<CR>"
      \ . "<html>\<CR>"
      \ . "<head>\<CR>"
      \ . "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\<CR>"
      \ . "<meta charset=\"utf-8\">\<CR>"
      \ . "<title></title>\<CR>"
      \ . "</head>\<CR>"
      \ . "<body>\<CR>\<CR>"
      \ . "</body>\<CR>"
      \ . "</html>\<Esc>"
      \ . "/title\<CR>f<\<C-b>"

au BufRead *.ipynb
      \ setlocal ft=json
au BufRead *.url
      \ setlocal ft=dosini
au BufRead,BufNewFile
      \ /usr/local/etc/nginx/*,
      \/usr/local/nginx/conf/*,
      \/etc/nginx/*
      \ setlocal ft=nginx
au BufRead */etc/aliases
      \ setlocal ft=sh

" au VimEnter *.rb,Rakefile NERDTree | wincmd w
" au BufEnter *.rb,Rakefile exe "silent! CocDisable"
" Configure ruby omni-completion to use the language client:
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
" au FileType ruby setlocal omnifunc=LanguageClient#complete
au FileType coffee,css,scss,html,javascript,
      \jinja,json,php,pug,R,ruby,rst,
      \sh,sql,tex,typescript,vim,yaml
      \ setlocal ts=2 sw=2 sts=2
au FileType sql
      \ setlocal ts=4 sw=4 sts=4
au FileType c,cpp,php
      \ setlocal commentstring=//\ %s
" au FileType help
"       \ silent! call ReadMode(1)
au FileType markdown
      \ syn match markdownError "\w\@<=\w\@="
au FileType php
      \ setlocal ft=html syn=php
au FileType tex
      \ setlocal spell spelllang=en_us colorcolumn=80 wrap foldlevel=10
au FileType tex,cpp
      \ nnoremap <leader>c :silent exec "!echo >> /tmp/_listener"<CR><C-b>
au FileType man
      \ setlocal so=0
au FileType vim
      \ setlocal keywordprg=:help
au FileType vim
      \ let b:coc_enabled = 0
au FileType vim
      \ let b:coc_start_at_startup = 0
au FileType jinja
      \ setlocal commentstring=<!--%s-->
au FileType apache,nginx
      \ setlocal commentstring=#\ %s
au FileType sql
      \ setlocal commentstring=--%s
au FileType haml
      \ setlocal wrap

" vim: ts=2 sw=2 sts=2 viewoptions-=options
