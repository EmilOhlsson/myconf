if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif

source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('config')
endif

highlight LspReferenceText cterm=bold gui=bold ctermbg=Blue ctermfg=White
highlight LspReferenceRead cterm=bold gui=bold ctermbg=Green ctermfg=White
highlight LspReferenceWrite cterm=bold gui=bold ctermbg=Red ctermfg=White
highlight CursorLine cterm=bold ctermbg=darkgrey

autocmd CursorHold * lua vim.lsp.buf.document_highlight()
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorMoved * lua vim.lsp.buf.clear_references()

filetype plugin indent on
