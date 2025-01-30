call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'echasnovski/mini.surround'

" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" Fuzzy searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Litee IDE like stuff
Plug 'ldelossa/litee.nvim'
Plug 'ldelossa/litee-calltree.nvim'
Plug 'ldelossa/litee-symboltree.nvim'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

Plug 'EmilOhlsson/FloatTerm.nvim'

if filereadable(expand('$HOME/myconf/local-plugins.vim'))
    source ~/myconf/local-plugins.vim
endif
call plug#end()
