
set ft=man nomod nolist ignorecase

map <SPACE> <C-D>
map b <C-U>
nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>
source ~/.vim/macros/less.vim

set scrolloff=5
set wrapscan
highlight Normal ctermbg=NONE
highlight Normal ctermfg=NONE
