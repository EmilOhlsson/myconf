call plug#begin()
" Helper tool for configuring LSP servers
Plug 'neovim/nvim-lspconfig'

" Tree-sitter helpers
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim', { 'commit': '7010000'}

" Litee IDE like stuff
Plug 'ldelossa/litee.nvim'
Plug 'ldelossa/litee-calltree.nvim'
Plug 'ldelossa/litee-symboltree.nvim'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

" Theme plugin
Plug 'rktjmp/lush.nvim'

" My own plugins
Plug 'EmilOhlsson/FloatTerm.nvim'       " Floating terminal
Plug 'EmilOhlsson/Highlighter.nvim'     " Highlight text objects

" Debug adapter protocol
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

" Experimenting with new plugins
Plug 'nvim-lua/plenary.nvim'                         " Useful for plenty of stuff
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' } " mini.nvim is a collection of plugins
Plug 'folke/snacks.nvim', { 'commit': '5eac729' }    " Pickers etc
Plug 'folke/trouble.nvim'                            " Better diagnostics
Plug 'folke/todo-comments.nvim'                      " TODO lists from comments

Plug 'MeanderingProgrammer/render-markdown.nvim', { 'commit': '6a744f0' } " v8.10.0

if filereadable(expand('$HOME/myconf/local-plugins.vim'))
    source ~/myconf/local-plugins.vim
endif
call plug#end()

" vim: set et ts=4 sw=4 ts=4 tw=80:
