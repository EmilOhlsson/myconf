call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'scrooloose/nerdtree'            " Support for nicer file browsing
Plug 'MattesGroeger/vim-bookmarks'    " mm - toggle bookmark on line
                                      " mi - add/edit/remove annotation
                                      " ma - show all bookmarks
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'ldelossa/litee.nvim'
Plug 'ldelossa/litee-calltree.nvim'
Plug 'ldelossa/litee-symboltree.nvim'

if filereadable(expand('$HOME/myconf/local-plugins.vim'))
    source ~/myconf/local-plugins.vim
endif
call plug#end()
