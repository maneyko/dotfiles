
" remaps
" ===========================================================================
"
let g:mapleader = ","

" spell check
nnoremap <silent> <leader>s :setlocal spell! spelllang=en_us<CR>

" redraw screen and remove highlights
nnoremap <silent> <C-l> :nohl<CR><C-l>

" enable relativenumber
nnoremap <silent> <C-n> :set relativenumber!<CR>

" use jk for scrolling the page
nnoremap <leader>v :call ReadMode(togg)<CR>

" change tabbing for whole file
nmap \t :set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab<CR>
      \:%retab!<CR>:echo "noexpandtab"<CR>
nmap \s :set tabstop=4 softtabstop=4 shiftwidth=4 expandtab<CR>
      \:%retab!<CR>:echo "expandtab"<CR>

" disable arrow keys
nnoremap <Up>       <NOP>
nnoremap <Down>     <NOP>
nnoremap <Left>     <NOP>
nnoremap <Right>    <NOP>

" paste from system register
inoremap <C-p>  <C-r>*
inoremap jk <ESC>

vnoremap . :normal .<CR>

