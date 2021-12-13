if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif

source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('config')
endif

highlight Cursorline term=bold cterm=bold ctermbg=darkgrey
highlight LspReferenceText cterm=bold gui=bold ctermbg=darkcyan ctermfg=white
highlight LspReferenceRead cterm=bold gui=bold ctermbg=darkgreen ctermfg=white
highlight LspReferenceWrite cterm=bold gui=bold ctermbg=darkred ctermfg=white

autocmd CursorHold * lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * lua vim.lsp.buf.clear_references()
autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}

filetype plugin indent on

colorscheme material
