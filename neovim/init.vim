source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('my-init')
endif

highlight LspReferenceText cterm=bold gui=bold ctermbg=4
highlight LspReferenceRead cterm=bold gui=bold ctermbg=6
highlight LspReferenceWrite cterm=bold gui=bold ctermbg=9

autocmd CursorHold * lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * lua vim.lsp.buf.clear_references()

if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif
