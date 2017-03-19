" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Rust plugins
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'

" C/C++ plugins
Plugin 'rip-rip/clang_complete'

" Additional text object
Plugin 'vim-scripts/argtextobj.vim'

call vundle#end()

filetype plugin indent on

syntax on			" Syntax highlighting
colorscheme elflord		" Nice color scheme on dark background

set mouse=a
set number                      " Show line numbers
set relativenumber              " Show relative numbers
set backspace=indent,eol,start  " Don't remember what this does...
set autoread                    " Don't remember what this does
set nowrap                      " Don't wrap long lines
set clipboard=unnamedplus       " Use the system clipboard
set noswapfile                  " Don't create swap files
set modeline                    " Read the mode line at the beginning of the file
set smartcase                   " Don't remember what this does
set incsearch                   " Search as you type
set spell                       " Enable spellchecking

" vim-racer configuration
set hidden
let g:racer_cmd = "racer"
let g:racer_experimental_completer = 1

" Enable clang-format wih Ctrl+k
map <C-K> :pyf ~/.vim/clang-format.py<cr>
imap <C-K> <c-o>:pyf ~/.vim/clang-format.py<cr>

" Add some extra inforamtion to the status line
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2

set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

function DevMode()
    set expandtab
    set smarttab
    set ts=4
    set tw=100
    set sw=4
    set ss=4
    set cin
endfunction
