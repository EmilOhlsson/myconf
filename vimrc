" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

""" Rust plugins
Plugin 'rust-lang/rust.vim'

""" Language servers
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'

""" C/C++ plugins
" List symbols from tagfiles with :TagbarToggle
Plugin 'majutsushi/tagbar'
Plugin 'Rip-Rip/clang_complete'

" Callgraph explorer
Plugin 'vim-scripts/CCTree'

""" Additional text object
" Support for argument manipulation (cia -> Change inner argument)
Plugin 'vim-scripts/argtextobj.vim'

" Syntax highlight
Plugin 'glensc/vim-syntax-lighttpd'

""" Align text
" Crate tables by :Tab /<symbol> to tabularize based on symbol
Plugin 'godlygeek/tabular'

" Git stuff
Plugin 'tpope/vim-fugitive'

" File handling
Plugin 'scrooloose/nerdtree'        " Support for nicer file browsing

call vundle#end()

filetype plugin indent on

syntax on                           " Syntax highlighting
colorscheme koehler

set autoread                        " Don't remember what this does
set backspace=indent,eol,start      " Don't remember what this does...
set clipboard=unnamedplus           " Use the system clipboard
set completeopt+=longest,preview    " Only complete common match, display extra information
set incsearch                       " Search as you type
set modeline                        " Read the mode line at the beginning of the file
set mouse=a                         " Activate mouse support
set noswapfile                      " Don't create swap files
set nowrap                          " Don't wrap long lines
set number                          " Show line numbers
set relativenumber                  " Show relative numbers
set showcmd                         " Let last executed command linger for reference
set showmatch                       " Show matching <([{
set smartcase                       " smart case when searching
set wildmenu                        " Show possible matches
set wildmode=longest,list,full      " Order of matching

" Check if file has been modified outside of Vim
autocmd CursorHold * checktime

" LSP configuration
" Check configure found language servers, 
if v:version > 800
    let g:vimrc_found_lsp = 0
    if executable('clangd')
        let g:vimrc_found_lsp = 1
        augroup lsp_clangd
            autocmd!    
            autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd']},
                \ 'whitelist': ['c', 'cpp'],
                \ })
        augroup end
    endif
    if executable('rls')
        let g:vimrc_found_lsp = 1
        augroup lsp_rls
            autocmd!    
            autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'rls',
                \ 'cmd': {server_info->['rls']},
                \ 'whitelist': ['rust'],
                \ })
        augroup end
    endif
    if g:vimrc_found_lsp
        autocmd FileType c,cpp,rust nnoremap <leader>lr :LspRename<cr>
        autocmd FileType c,cpp,rust setlocal omnifunc=lsp#complete
        autocmd FileType c,cpp,rust setlocal omnifunc=lsp#complete
    endif
endif

" vim-racer configuration
set hidden
let g:racer_cmd = "racer"
let g:racer_experimental_completer = 1

" Syntastic configuration
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rust_checkers = ['cargo']

let g:clang_library_path = '/usr/lib/llvm-6.0/lib/libclang.so'

" Enable clang-format wih Ctrl+k
map <C-K> :pyf ~/.vim/clang-format.py<cr>
imap <C-K> <c-o>:pyf ~/.vim/clang-format.py<cr>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
noremap <leader>cr :pyf /usr/share/clang/clang-rename.py<cr>

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
endfunction

function LinuxDevMode()
    set noexpandtab
    set smarttab
    set ts=8
    set tw=100
    set sw=8
    set ss=8
    set cin
endfunction

