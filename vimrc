syntax on			" Syntax highlighting
colorscheme desert		" Nice colorscheme on dark background

set mouse=a
set number			" Show line numbers
set backspace=indent,eol,start	" Don't remember what this does...
set autoread			" Don't remember what this does
set nowrap			" Don't wrap long lines
set clipboard=unnamedplus	" Use the system clipboard
set noswapfile			" Don't create swap files
set modeline			" Read the modeline at the beginning of the file
set smartcase			" Don't remember what this does
set incsearch                   " Search as you type

filetype plugin indent on
set ofu=syntaxcomplete#Complete

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
