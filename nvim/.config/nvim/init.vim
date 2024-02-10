"""" Plugin manager and plugins
" Install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Initialize Vim-Plug and list your plugins here
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'rose-pine/vim'
Plug 'ThePrimeagen/vim-be-good'
" Commentary plugin
"    basic operation:
" 	gc{motion} to comment/uncomment
"    :h commentary
" Note: this plugin adds a custom operator to vim
Plug 'tpope/vim-commentary'
" textobj entire plugin
"    basic operation:
"       {operator/command}ae. e.g. vae: select all file `ggVG', =ae: ident the
"       whole file
"    :h textobj-entire
" Note: this plugin add a custom motion to vim
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
" Surround plugin
Plug 'tpope/vim-surround'
call plug#end()

" editor options
set guicursor= " bold cursor
set scrolloff=8 " freeze scrolling at 8 lines down/up
set smartindent

" set highligh search
set hlsearch
" set tab width to 4
set tabstop=4
" insert spaces instead of tab
set expandtab
" ident (> & <) using 4 spaces
set shiftwidth=4
" backspace deletes 4 empty characters
set softtabstop=4
" show line numbers
set number
" show relative line numbers
set relativenumber
" disable the beep
set visualbell
set t_vb=
" autocompletion for command mode - zsh style
set wildmenu
set wildmode=full
" increase history size, default is 20
set history=200
" enable hidden files (move while there is a change that has not
" been written)
set hidden
" enable mouse
" set mouse=nvi
" enable increamental search 
set incsearch

"""" Key maps
" Git files  
nnoremap <C-p> :GFiles<CR>  
" Jump Quick fix item list
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR> 
" gv highlights the last highlighted section
" and it shall also move the highlighted text up and down with J & K 
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" map a key to mute search highlighting
" c-u: clears any existing command line input
" c-l: refresh the display
nnoremap <silent> <c-l> :<c-u>nohlsearch<cr><c-l>
" cycle through the open buffer list
" TODO: Those keymaps and more can be found in
" tim pope plugin https://github.com/tpope/vim-unimpaired
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" expands the path of the active buffer with %% keymap in command  
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" disable the arrow keys in normal mode (learn by force)
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

let mapleader = " "
" paste the yanked buffer in a new line
nnoremap <leader>p o<esc>Pk 
" paste the yanked text over highlighted text while keeping the original yank buffer
vnoremap <leader>p "_dP 
" '+' reg is the clipboard, yank and send to the system clipboard
vnoremap <leader>y "+y 
" doesn't work at the moment, should enter yank mode and let me mark later
nnoremap <leader>y "+y 
nnoremap <leader>Y gg"+yG " Copy a complete file into the clipboard
" project view vertically
nnoremap <leader>pv :Vex<CR>    
" source nvim configuration 
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR> 
" project files
nnoremap <leader>pf :Files<CR> 
" list open buffers
nnoremap <leader>pb :Buffers<CR> 

" color scheme
" This was from colorscheme section
set termguicolors     " enable true colors support
set background=dark
colorscheme rosepine

