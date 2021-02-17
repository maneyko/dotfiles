" vimrc
" =====
"
" Table of Contents
" -----------------
"   * Sets
"   * Plugins
"   * Functions
"   * Remaps
"   * Auto Commands
"   * Colors

let g:minimal_vimrc = 0

set nocompatible
filetype off

call plug#begin()

" Sets
" ====
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
set listchars=tab:>-,trail:⋅
if has('mouse')
  set mouse=a
  if !has('nvim')
    set ttymouse=xterm2
  endif
endif
if version >= 702
  au InsertLeave * set list
  au InsertEnter * set nolist
endif
set nowildmenu
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

let g:netrw_dirhistmax=0  " no .netrwhist files

if has('nvim')
  set guicursor=
  set laststatus=0
endif

" Plugins
" =======
"
" Core
" ----
Plug 'junegunn/vim-plug'
Plug 'mkarmona/colorsbox'          " color scheme
Plug 'alvan/vim-closetag'
let g:closetag_filenames = '*.html,*.xhtml,*.xml'

Plug 'jiangmiao/auto-pairs'        " completes pairs
Plug 'tpope/vim-commentary'        " commenting motions
Plug 'tpope/vim-endwise'           " closes functions (if and fi)
Plug 'tpope/vim-repeat'            " '.' for plugins
Plug 'tpope/vim-surround'          " surrounding motions
Plug 'tpope/vim-unimpaired'        " bracket functions and more
if !has('nvim')
  Plug 'vim-utils/vim-man'
endif

if !minimal_vimrc
  " Navigation
  " ----------
  Plug 'ctrlpvim/ctrlp.vim'          " fuzzy file finder
    let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
        \ 'AcceptSelection("t")': ['<cr>'],
    \ }
    let g:ctrlp_regexp = 1

  Plug 'scrooloose/nerdtree'         " filetree
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    let NERDTreeShowHidden=1
    let g:NERDTreeGitStatusIndicatorMapCustom = {
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
    " let NERDTreeMapOpenInTab='<ENTER>'  " As a consequence, this disables 't' as the new tab opener :/

  Plug 'yegappan/mru'

  Plug 'mileszs/ack.vim'
    if executable('ag')
      let g:ackprg = 'ag --vimgrep --smart-case'
    endif

    let g:ack_mappings = {
          \ "t": "<C-W><CR><C-W>j<C-W>c<C-W>T<C-l>",
          \ "<cr>": "<C-W><CR><C-W>j<C-W>c<C-W>T<C-l>",
          \ "T": "<C-W><CR><C-W>j<C-W>c<C-W>TgT<C-W>j<C-l>" }

  " Functional
  " ----------
  Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

  " Syntax
  " ------
  Plug 'martinda/Jenkinsfile-vim-syntax'
  Plug 'phreax/vim-coffee-script'
  Plug 'vim-scripts/nginx.vim'       " nginx
  Plug 'digitaltoad/vim-pug'
  Plug 'gisphm/vim-gitignore'        " .gitignore files
  Plug 'vim-python/python-syntax'

  Plug 'tpope/vim-markdown'
    let g:markdown_fenced_languages = ['bash=sh', 'html', 'python', 'ruby', 'sql', 'yaml']
    let g:markdown_syntax_conceal = 0

  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-rake'

  Plug 'tpope/vim-rails'
    let rails_projections = {
      \  "rubyMacro": [
      \    "before", "after", "around", "background", "setup", "teardown", "context", "describe",
      \    "feature", "shared_context", "shared_examples", "shared_examples_for",
      \    "let", "subject", "it", "example", "specify", "scenario", "include_examples", "include_context",
      \    "it_should_behave_like", "it_behaves_like"
      \  ],
      \  "rubyAction": [
      \    "expect", "is_expected", "expect_any_instance_of", "allow", "allow_any_instance_of",
      \    "stub_const", "hide_const"
      \  ],
      \  "rubyHelper": [
      \    "described_class", "double", "instance_double", "class_double", "object_double",
      \    "spy", "instance_spy", "class_spy", "object_spy", "anything", "page"
      \   ]
      \ }

    let g:rails_projections = {
    \   "*_spec.rb": rails_projections,
    \   "spec/support/*.rb": rails_projections
    \ }

  " Completion
  " ----------
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

  if executable('node')
    if has('nvim')
      Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
    else
      Plug 'neoclide/coc.nvim'
    endif
    if !has('patch-8.0-1453')
      let g:coc_disable_startup_warning = 1
    endif
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction
      " let g:coc_global_extensions = ['coc-solargraph']
  endif

  " Miscellaneous
  " -------------
  Plug 'tpope/vim-fugitive'          " git integration
  Plug 'mattn/emmet-vim'             " html completion
    if has('nvim')
      let g:user_emmet_leader_key = '<C-space>'
    else
      let g:user_emmet_leader_key = '<NUL>'
    endif

  " Disabled
  " --------
  " let g:do_refresh_key = '<C-M>'
  " let g:SuperTabCrMapping = 1
  " let g:SuperTabDefaultCompletionType = "<c-n>"
  " let g:vimpager = {}
  " let g:less = {}
  " let g:less.enabled = 0
  " let g:less.scrolloff = 5
endif

" Functions
" =========
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
    execute "normal! 0100lf\<space>r\<cr>"
  endfor
endfun


" Remaps
" ======
let g:mapleader = ','

cnoremap <C-A>            <C-b>

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
nnoremap <leader>a        :Ack!<space>
nnoremap <leader>f        :call FlyMode(flymode_togg)<CR>
nnoremap <leader>kq       :q!<CR>
nnoremap <leader>n        :NERDTreeToggle<CR>
nnoremap <leader>ps       :%s/\<and\>\\|\<as\>\\|\<by\>\\|\<count\>\\|\<false\>\\|\<from\>\\|\<group\>\\|\<in\>\\|\<join\>\\|\<left\>\\|\<null\>\\|\<on\>\\|\<or\>\\|\<order\>\\|\<right\>\\|\<select\>\\|\<sum\>\\|\<true\>\\|\<update\>\\|\<where\>\\|\<with\>/\U&/ge<esc>
nnoremap <leader>q        :q<CR>
nmap     <leader>r        <Plug>(coc-references)
nnoremap <leader>m        :MRU<CR>
nnoremap <leader>s        :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>kw       :w !sudo tee %<CR>
" nnoremap <space>          <C-d>
nnoremap \a               :<C-U>call AlignRow(v:count1)<CR>
nnoremap \d               :%s/\r\+$//g<CR>
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
vnoremap \y               "ly
vnoremap \p               "lp

map <ScrollWheelUp>       <C-y>
map <ScrollWheelDown>     <C-e>
if has('nvim')
  map <2-ScrollWheelUp>     <C-y>
  map <3-ScrollWheelUp>     <C-y>
  map <4-ScrollWheelUp>     <C-y>
  map <2-ScrollWheelDown>   <C-e>
  map <3-ScrollWheelDown>   <C-e>
  map <4-ScrollWheelDown>   <C-e>
endif

" Auto Commands
" =============
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
au BufNewFile *_spec.rb
      \ exe "normal! ggcGRSpec.describe " .
      \ substitute(substitute(expand('%:t')[:-9], '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', "g"),'^.','\u&','')
      \ . " do\<CR>\<CR>end\<Esc>ggj"
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
au BufRead pom.xml
      \ setlocal sw=2 ts=2 sts=2
au BufRead *.url
      \ setlocal ft=dosini
au BufRead Dockerfile*
      \ setlocal ft=dockerfile
au BufRead *.simplecov
      \ setlocal ft=ruby
au BufRead,BufNewFile
      \ /usr/local/etc/nginx/*,
      \/usr/local/nginx/conf/*,
      \/etc/nginx/*,
      \*nginx.conf
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

" Colors
" ======
call plug#end()

filetype plugin indent on

if !empty(glob($VIMRUNTIME . '/syntax/syntax.vim'))
  syntax on
endif

if has('nvim')
  let config_dir = '~/.dotfiles/config/nvim'
else
  let config_dir = '~/.dotfiles/vim/'
endif

if isdirectory(glob(config_dir . '/plugged/colorsbox'))
  colorscheme colorsbox-stnight
endif

" Make text yellow for ack.vim
if has('nvim')
  highlight QuickFixLine ctermfg=Yellow ctermbg=NONE cterm=bold
endif

" Make bg and fg colors same as terminal
highlight Normal ctermbg=NONE
highlight Normal ctermfg=NONE


if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif


" vim: ts=2 sw=2 sts=2 viewoptions-=options
