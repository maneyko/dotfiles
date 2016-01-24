" UI
" ===========================================================================
"
" visuals
set number                      " line numbers
set ruler                       " line & columns numbers on bottom
set showcmd                     " show command on bottom
set numberwidth=3               " width of line number column
set hlsearch                    " highlight search
set incsearch                   " move while typing search pattern
set scrolloff=5                 " keep cursor 5 lines frop top/bottom
set showbreak=...               " show ellipsis when going over
set list
set listchars=tab:\ \ ,trail:⋅

" tab control
set tabstop=4                   " <tab> == 4 spaces
set shiftwidth=4                " number of spaces for indent and unindent
set softtabstop=4               " edit 4 spaces as if they are tabs
set expandtab                   " tab makes spaces
set autoindent                  " automatically indent new lines
set smartindent                 " knows when to indent
set smarttab                    " tab respects tab settings completely

" misc
set ignorecase                  " ignore case for search
set clipboard=unnamed           " system clipboard
set tildeop                     " tilde operator for changing CASE
let g:netrw_dirhistmax = 0      " no .netrwhist files

" colors
" ======================================
"
syntax on                       " syntax highlighting
set t_Co=256                    " terminal supports 256 colors

colorscheme colorsbox-stnight

" make bg and fg colors same as terminal
highlight Normal ctermbg=NONE
highlight Normal ctermfg=NONE

