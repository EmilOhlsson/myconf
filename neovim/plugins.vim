call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'majutsushi/tagbar'              " File overview for C/C++
Plug 'vim-scripts/argtextobj.vim'     " Argument manipulation (cia -> change inner argument)
Plug 'godlygeek/tabular'              " Crate tables by :Tab /<symbol> to tabularize based on symbol
Plug 'scrooloose/nerdtree'            " Support for nicer file browsing
Plug 'MattesGroeger/vim-bookmarks'    " mm - toggle bookmark on line
                                      " mi - add/edit/remove annotation
                                      " ma - show all bookmarks
call plug#end()
