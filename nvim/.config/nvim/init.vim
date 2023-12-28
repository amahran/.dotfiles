set guicursor= " bold cursor
set scrolloff=8 " freeze scrolling at 8 lines down/up
set number " show line numbers
set relativenumber " make the line numbers relative
set tabstop=4 softtabstop=4 " tab is 4 spaces
set shiftwidth=4
set expandtab " insert spaces instead of tabs
set smartindent

" Add fzf plugin and ayu theme plugin
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'rose-pine/vim'
Plug 'ThePrimeagen/vim-be-good'
call plug#end()

" This was from colorscheme section
set termguicolors     " enable true colors support
let ayucolor="dark"   " for dark version of theme
colorscheme ayu 
"set background=dark
"colorscheme rosepine

"""""""""""""""""""""""""""""""""""""""
" KEY MAPS
"""""""""""""""""""""""""""""""""""""""
let mapleader = " "
" project view vertically
nnoremap <leader>pv :Vex<CR>    
" source nvim configuration 
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR> 
" Git files  
nnoremap <C-p> :GFiles<CR>  
" project files
nnoremap <leader>pf :Files<CR> 
" list open buffers
nnoremap <leader>pb :Buffers<CR> 
" Jump Quick fix item list
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR> 
" paste the yanked buffer in a new line
nnoremap <leader>p o<esc>Pk 
" paste the yanked text over highlighted text while keeping the original yank buffer
vnoremap <leader>p "_dP 
" '+' reg is the clipboard, yank and send to the system clipboard
vnoremap <leader>y "+y 
" doesn't work at the moment, should enter yank mode and let me mark later
nnoremap <leader>y "+y 
nnoremap <leader>Y gg"+yG " Copy a complete file into the clipboard
" gv highlights the last highlighted section
" and it shall also move the highlighted text up and down with J & K 
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

