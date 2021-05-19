" Vundle setup
set nocompatible
filetype off
set shell=/bin/bash
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'

Plugin 'rust-lang/rust.vim'             " Rust support
Plugin 'neoclide/coc.nvim'              " LSP support
                                        " :CocInstall coc-clangd
                                        " :CocInstall coc-rls
Plugin 'majutsushi/tagbar'              " File overview for C/C++
Plugin 'vim-scripts/argtextobj.vim'     " Argument manipulation (cia -> change inner argument)
Plugin 'tikhomirov/vim-glsl'            " GLSL syntax highlighting
Plugin 'godlygeek/tabular'              " Crate tables by :Tab /<symbol> to tabularize based on symbol
Plugin 'tpope/vim-fugitive'             " Git stuff
Plugin 'scrooloose/nerdtree'            " Support for nicer file browsing
Plugin 'kien/ctrlp.vim'                 " Fuzzy searching
Plugin 'MattesGroeger/vim-bookmarks'    " mm - toggle bookmark on line
                                        " mi - add/edit/remove annotation
                                        " ma - show all bookmarks
Plugin 'embear/vim-localvimrc'          " Local vimrc

call vundle#end()

filetype plugin indent on

syntax on                           " Syntax highlighting

if has('nvim')
  set inccommand=split                " Use Neovim search/replace
endif
set autoread                        " Don't remember what this does
set backspace=indent,eol,start      " Don't remember what this does...
set clipboard=unnamedplus           " Use the system clipboard
set completeopt+=longest,preview    " Only complete common match, display extra information
set encoding=utf-8                  " Assume utf-8 support of terminal
set cmdheight=2
set signcolumn=yes
set hlsearch                        " Highlight search results
set incsearch                       " Search as you type
set modeline                        " Read the mode line at the beginning of the file
set mouse=a                         " Activate mouse support
set noswapfile                      " Don't create swap files
set nowrap                          " Don't wrap long lines
set shortmess+=c
set number                          " Show line numbers
set relativenumber                  " Show relative numbers
set showcmd                         " Let last executed command linger for reference
set showmatch                       " Show matching <([{
set ignorecase                      " Ignore casing when searching
set smartcase                       " Do not ignore case if upper case is used
set wildmenu                        " Show possible matches
set wildmode=longest,list,full      " Order of matching
set hidden                          " Buffers are hidden instead of closed

set wrap                                 " Wrap long lines
set linebreak                            " break long lines at words
set showbreak=>>                         " Prefix wrapped lines with >>
set breakindent                          " Indent wrapped lines
set breakindentopt=shift:40,sbr          " indent with 32 chars, ShowBReak before indent
set updatetime=300

nmap <leader>rn <plug>(coc-rename)
nmap <leader>lsi :CocCommand clangd.symbolInfo
nmap <leader>lsh :CocCommand clangd.switchSourceHeader
nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>le <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>ld <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lr <Plug>(coc-references)

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Check if file has been modified outside of Vim
autocmd CursorHold * checktime

" Local vimrc configuration
let g:localvimrc_ask=0
let g:localvimrc_count=1

" Enable clang-format wih Ctrl+k
map <C-K> :pyf ~/.vim/clang-format.py<cr>
imap <C-K> <c-o>:pyf ~/.vim/clang-format.py<cr>

map <leader>p :CtrlP<cr>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
" noremap <leader>cr :pyf /usr/share/clang/clang-rename.py<cr>

" Add some extra inforamtion to the status line
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2

function DevMode()
    set expandtab
    set smarttab
    set ts=4
    set tw=100
    set sw=4
    set ss=4
    set cin
    set cursorline
endfunction

function LinuxDevMode()
    set noexpandtab
    set smarttab
    set ts=8
    set tw=100
    set sw=8
    set ss=8
    set cin
    set colorcolumn=80
endfunction

if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif
