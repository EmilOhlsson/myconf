if has('nvim')
  set inccommand=split                " Use Neovim search/replace
endif

set autoread                        " Don't remember what this does
set backspace=indent,eol,start      " Don't remember what this does...
set clipboard=unnamedplus           " Use the system clipboard
set completeopt=menuone,noselect    " Only complete common match, display extra information
set encoding=utf-8                  " Assume utf-8 support of terminal
set signcolumn=yes
set hlsearch                        " Highlight search results
set incsearch                       " Search as you type
set modeline                        " Read the mode line at the beginning of the file
set mouse=a                         " Activate mouse support
set noswapfile                      " Don't create swap files
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
set updatetime=300  " How often to check file, affects autoread, cursorhold etc
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2
set exrc                            " Load local vimrc
