
" functions
" ===========================================================================
"
if has('autocmd')
  autocmd BufNewFile,BufRead *tmux.conf set ft=sh
  autocmd Filetype vim setlocal ts=2 sw=2 sts=2 expandtab
endif

if has("mouse")
  set mouse=a
endif

if version >= 702
  au InsertEnter * :set nolist    " dont list trailing chars in insert
  au InsertLeave * :set list
endif

function LessInitFunc()
  highlight Normal ctermbg=NONE
  highlight Normal ctermfg=NONE
  set hlsearch incsearch wrapscan nonumber nolist
  set so=999
  if @% == '' | set ft=man | endif
endfunction

function! ReadMode(togg)
  if a:togg==0
    echo "Read Mode on"
    set so=999
    nnoremap q :q<CR>
    let g:togg=1
  else
    echo "Read Mode off"
    set so=5
    nunmap q
    let g:togg=0
  endif
endfunction
let g:togg=0
silent call ReadMode(togg)

