call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'majutsushi/tagbar'              " File overview for C/C++
" Plug 'vim-scripts/argtextobj.vim'     " Argument manipulation (cia -> change inner argument)
Plug 'godlygeek/tabular'              " Crate tables by :Tab /<symbol> to tabularize based on symbol
Plug 'scrooloose/nerdtree'            " Support for nicer file browsing
Plug 'MattesGroeger/vim-bookmarks'    " mm - toggle bookmark on line
                                      " mi - add/edit/remove annotation
                                      " ma - show all bookmarks
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'
Plug 'luochen1990/rainbow'
Plug 'marko-cerovac/material.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
