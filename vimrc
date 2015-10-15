syntax on			" Syntax highlighting

set mouse=a
set number
set backspace=indent,eol,start
set autoread
set nowrap
set clipboard=unnamedplus
set noswapfile
set modeline
set smartcase
set incsearch                   " Search as you type

filetype plugin indent on
set ofu=syntaxcomplete#Complete

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
