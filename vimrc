" Vundle setup
set nocompatible
filetype off
set shell=/bin/bash
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

""" Rust plugins
Plugin 'rust-lang/rust.vim'

""" Language servers
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/vim-lsp'

""" C/C++ plugins
" List symbols from tagfiles with :TagbarToggle
Plugin 'majutsushi/tagbar'

""" Python
" lsp support for python
Plugin 'ryanolsonx/vim-lsp-python'

" Callgraph explorer
Plugin 'vim-scripts/CCTree'

""" Additional text object
" Support for argument manipulation (cia -> Change inner argument)
Plugin 'vim-scripts/argtextobj.vim'

" Syntax highlight
Plugin 'glensc/vim-syntax-lighttpd'
Plugin 'tikhomirov/vim-glsl'

""" Align text
" Crate tables by :Tab /<symbol> to tabularize based on symbol
Plugin 'godlygeek/tabular'

" Git stuff
Plugin 'tpope/vim-fugitive'

" File handling
Plugin 'scrooloose/nerdtree'        " Support for nicer file browsing

" Fuzzy searching
Plugin 'kien/ctrlp.vim'

" Bookmarks
Plugin 'MattesGroeger/vim-bookmarks'    " mm - toggle bookmark on line
                                        " mi - add/edit/remove annotation
                                        " ma - show all bookmarks
" Local vimrc
Plugin 'embear/vim-localvimrc'      " Local vimrc

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
set hlsearch                        " Highlight search results
set incsearch                       " Search as you type
set modeline                        " Read the mode line at the beginning of the file
set mouse=a                         " Activate mouse support
set noswapfile                      " Don't create swap files
set nowrap                          " Don't wrap long lines
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

" Check if file has been modified outside of Vim
autocmd CursorHold * checktime

" LSP configuration
" Check configure found language servers, 
if v:version >= 800 && $SKIP_LSP != 'y'
    let g:vimrc_found_lsp = 0
    if executable('ccls')
        let g:vimrc_found_lsp = 1
        augroup lsp_ccls
            autocmd!    
            autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'ccls',
                \ 'root_uri': {
                \   server_info->lsp#utils#path_to_uri(
                \       lsp#utils#find_nearest_parent_file_directory(
                \           lsp#utils#get_buffer_path(), 'compile_commands.json'
                \       )
                \   )
                \ },
                \ 'cmd': {server_info->['ccls']},
                \ 'whitelist': ['c', 'cc', 'cpp'],
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
    if executable('pyls')
        let g:vimrc_found_lsp = 1
        augroup lsp_pyls
            autocmd!
            autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ })
        augroup end
    endif
    if g:vimrc_found_lsp
        autocmd FileType c,cpp,rust,python nnoremap <leader>lr :LspReferences<cr>
        autocmd FileType c,cpp,rust,python nnoremap <leader>ld :LspDefinition<cr>
        autocmd FileType c,cpp,rust,python nnoremap <leader>ln :LspRename<cr>
        autocmd FileType c,cpp,rust,python nnoremap <leader>le :LspNextError<cr>
        autocmd FileType c,cpp,rust,python nnoremap <leader>ls :LspNextReference<cr>
        autocmd FileType c,cpp,rust,python nnoremap <C-H> :LspHover<cr>
        autocmd FileType c,cpp,rust,python inoremap <C-H> <c-o>:LspHover<cr>
        autocmd FileType c,cpp,rust,python setlocal omnifunc=lsp#complete
    endif
endif

" Syntastic configuration
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rust_checkers = ['cargo']

" asyncomplete configuration
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 0

" LSP configuration
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_highlight_references_enabled = 1
highlight lspReference ctermfg=white ctermbg=green

" Local vimrc configuration
let g:localvimrc_ask=0
let g:localvimrc_count=1

" Enable clang-format wih Ctrl+k
map <C-K> :pyf ~/.vim/clang-format.py<cr>
imap <C-K> <c-o>:pyf ~/.vim/clang-format.py<cr>

map <leader>p :CtrlP<cr>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
noremap <leader>cr :pyf /usr/share/clang/clang-rename.py<cr>

noremap <leader>uc :%s/\[\d\+\(;\d\+\)*m//g<cr>

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

