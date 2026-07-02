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

if filereadable(expand("$HOME/.vimrc.local.preload"))
  source $HOME/.vimrc.local.preload
endif

let g:minimal_vimrc = get(g:, 'minimal_vimrc', 1)

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
set encoding=utf-8
set fileencoding=utf-8
set ambiwidth=double
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
set noerrorbells visualbell t_vb=
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

  " Is required for neovim>=0.10 (https://github.com/neovim/neovim/issues/29056)
  " https://neovim.io/doc/user/news-0.10.html#_breaking-changes
  if has('nvim-0.10')
    " Also perhaps COLORTERM=truecolor (https://github.com/neovim/neovim/issues/28776)
    set notermguicolors
  endif

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
let g:AutoPairsShortcutToggle     = ''
let g:AutoPairsShortcutFastWrap   = ''
let g:AutoPairsShortcutJump       = ''
let g:AutoPairsShortcutBackInsert = ''

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
    let g:ctrlp_custom_ignore = 'target\/docker\|node_modules\|venv'

  Plug 'neovim/nvim-lspconfig'
  Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }

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
    autocmd BufEnter * if (winnr("$") == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | quit | endif
    autocmd VimLeave *  if !v:dying | execute 'tabdo NERDTreeClose' | endif
    " autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif " This breaks `ack.vim`.
    autocmd BufEnter * if winwidth('%') > 220 | let g:NERDTreeWinSize = 64 | endif
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
  " Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'martinda/Jenkinsfile-vim-syntax'
  Plug 'phreax/vim-coffee-script'
  Plug 'towolf/vim-helm'
  Plug 'vim-scripts/nginx.vim'       " nginx
  Plug 'digitaltoad/vim-pug'
  Plug 'hashivim/vim-terraform'
  " Plug 'jbmorgado/vim-pine-script'
  Plug 'gisphm/vim-gitignore'        " .gitignore files
  Plug 'Vimjas/vim-python-pep8-indent' " Fix Python newline indentation
  Plug 'vim-python/python-syntax'
    let g:python_highlight_space_errors = 0
    let g:python_highlight_all = 1
    " let g:python_highlight_string_format = 1
    " let g:python_highlight_builtin_objs  = 1

  " Plug 'yuezk/vim-js'
  " Plug 'maxmellon/vim-jsx-pretty'

  " Plug 'tomlion/vim-solidity'

  Plug 'tpope/vim-markdown'
    let g:markdown_fenced_languages = ['bash=sh', 'html', 'python', 'ruby', 'sql', 'yaml', 'perl', 'diff', 'groovy', 'javascript']
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

  " Plug 'autozimu/LanguageClient-neovim', {
  "     \ 'branch': 'next',
  "     \ 'do': 'bash install.sh',
  "     \ }

  " let g:LanguageClient_serverCommands = {
  "     \ 'ruby': ['/usr/bin/env', 'solargraph', 'stdio'],
  "     \ }

"  if executable('node')
"    if has('nvim')
"      Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
"
"      " Notes:
"      " * 'suggest' is the menu that comes up when you press '.'
"      " * 'signature' is when you enter '('
"      " * 'diagnostics' are the warnings by the line numbers (linter errors, etc.)
"      " * 'snippet' is when there is a '~' in the suggestion
"
"
"      " Plug 'github/copilot.vim'  " Requires Node 20+
"      "   let g:copilot_node_command = "~/.nvm/versions/node/v20.19.2/bin/node"
"      "   inoremap <C-[> <Plug>(copilot-previous)
"      "   inoremap <C-]> <Plug>(copilot-next)
"      "   inoremap <C-l> <Plug>(copilot-dismiss)
"    else
"      Plug 'neoclide/coc.nvim'
"    endif
"    if !has('patch-8.0-1453')
"      let g:coc_disable_startup_warning = 1
"    endif
"
"    inoremap <silent><expr> <TAB>
"          \ coc#pum#visible() ? coc#pum#next(1) :
"          \ CheckBackspace() ? "\<Tab>" :
"          \ coc#refresh()
"    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"    " Note: <C-e> cancels the popup menu
"
"    function! CoCEnterOverride() abort
"      if coc#pum#has_item_selected()
"        return coc#pum#confirm()
"      else
"        return "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"      endif
"    endfunction
"    " inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"    "                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"    inoremap <silent><expr> <CR> CoCEnterOverride()
"
"    function! CheckBackspace() abort
"      let col = col('.') - 1
"      return !col || getline('.')[col - 1]  =~# '\s'
"    endfunction
"
"    " Remap <C-f> and <C-b> to scroll float windows/popups
"    if has('nvim-0.4.0') || has('patch-8.2.0750')
"      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"    endif
"
"    let g:coc_disable_transparent_cursor = 1
"
"    " let g:coc_global_extensions = ['coc-solargraph']
"  endif

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
call plug#end()

lua << EOF
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ["<Tab>"] = { 'accept' }
  },
  -- appearance = {
  --   nerd_font_variant = 'mono'
  -- },
  completion = {
    documentation = { auto_show = false }
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning"
  }
})
EOF


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
    silent! nnoremap <buffer> g gg
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
    silent! nunmap <buffer> g
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
nnoremap <C-i>            :tabprevious<CR>
nnoremap <tab>            :tabprevious<CR>
nnoremap <S-tab>          :tabnext<CR>
nnoremap <C-w><tab>       :tabmove -1<CR>
nnoremap <C-o>            :tabnext<CR>
nnoremap <C-w><C-o>       :tabmove +1<CR>
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
inoremap <C-p>            <C-o>k
inoremap <C-n>            <C-o>j
inoremap <C-w>            <C-o><C-w>
inoremap <M-b>            <C-o>dd
inoremap <M-f>            <C-o>w
inoremap jk               <Esc>

vnoremap .                :normal! .<CR>
vnoremap &                :normal! &<CR>
vnoremap \y               "ly
vnoremap \p               "lp
vnoremap f                zf

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

if has('nvim')
  lua << EOT
    -- vim.lsp.enable('pyright')
    -- vim.lsp.enable('pylsp')
    vim.lsp.config('pylsp', {
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = {'W391'},
              maxLineLength = 100
            }
          }
        }
      }
    })
    -- require'nvim-treesitter'.install { 'python' }
    -- vim.api.nvim_create_autocmd('FileType', {
    --   pattern = { 'python' },
    --   callback = function()
    --     vim.treesitter.start()
    --     vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    --   end,
    -- })
EOT
endif

" au BufLeave *__doc__*,help
"       \ silent! call ReadMode(0)
" au BufNewFile *__doc__*
"       \ silent! call ReadMode(1)
au BufNewFile *.sh,*.bash
      \ exe "normal! i#!/bin/bash\<CR>\<BS>\<CR>\<Esc>"
au BufNewFile *.rb
      \ exe "normal! i# frozen_string_literal: true\<CR>\<BS>\<BS>\<CR>class " .
      \ substitute(substitute(expand('%:t')[:-4], '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', "g"),'^.','\u&','')
      \ . "\<CR>\<CR>end\<Esc>gg3j"
au BufNewFile *_spec.rb
      \ exe "normal! k\"kcGRSpec.describe " .
      \ substitute(substitute(expand('%:t')[:-9], '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', "g"),'^.','\u&','')
      \ . " do\<CR>\<CR>end\<Esc>ggj"
au BufNewFile *.node
      \ exe "normal! i#!/usr/bin/env node\<CR>\<Esc>"
au BufNewFile *.py
      \ exe "normal! iclass " .
      \ substitute(substitute(expand('%:t')[:-4], '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', "g"),'^.','\u&','')
      \ . ":\<CR>pass\<CR>"
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
au BufRead *.jsonl
      \ setlocal ft=json
au BufRead settings.xml,pom.xml
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
au BufRead
      \ */etc/aliases/,
      \*.env*
      \ setlocal ft=sh

" au VimEnter *.rb,Rakefile NERDTree | wincmd w
" au BufEnter *.rb,Rakefile exe "silent! CocDisable"
" Configure ruby omni-completion to use the language client:
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" au FileType ruby setlocal omnifunc=LanguageClient#complete
au FileType bash,coffee,css,scss,helm,html,javascript,
      \jinja,json,jq,markdown,php,pug,R,ruby,rst,
      \sh,sql,tex,typescript,vim,yaml
      \ setlocal ts=2 sw=2 sts=2
au FileType c,cpp,php,psl
      \ setlocal commentstring=//\ %s
" au FileType help
"       \ silent! call ReadMode(1)
au FileType markdown
      \ syn match markdownError "\w\@<=\w\@="
if has('nvim-0.12')
  au FileType markdown
        \ call v:lua.vim.treesitter.stop()
endif
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
au FileType apache,nginx,eruby.yaml,terraform
      \ setlocal commentstring=#\ %s
au FileType sql
      \ setlocal commentstring=--\ %s
au FileType haml
      \ setlocal wrap

" Colors
" ======
filetype plugin indent on

if !empty(glob($VIMRUNTIME . '/syntax/syntax.vim'))
  syntax on
endif

colorscheme colorsbox-stnight

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
