set rtp^=$HOME/myconf/neovim rtp+=$HOME/myconf/neovim/after

if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif

source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('config')
endif

" TODO: Should probably move these to the on_attach in lua code
autocmd CursorHold * lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * lua vim.lsp.buf.clear_references()
autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}

filetype plugin indent on
colorscheme koehler

set cursorline

" TODO: This would probably be more convient with some kind of Lua table setup
highlight @class.declaration guibg=Purple4
highlight @declaration.identifier guibg=DarkSlateGray
highlight @function guibg=Maroon
highlight @function.call guibg=NavyBlue
highlight @method guibg=Maroon
highlight @note guibg=blue guifg=orange
highlight @todo guibg=orange guifg=blue
highlight CursorLine guibg=grey20
highlight DiffAdd cterm=none ctermbg=lightblue
highlight DiffChange cterm=none ctermbg=LightMagenta
highlight DiffText cterm=none ctermbg=LightCyan
highlight LTSymbol guifg=orange gui=bold
highlight LTSymbolDetail guifg=lightblue
highlight LspReferenceRead cterm=none gui=none ctermbg=darkgreen guibg=green ctermfg=white guifg=white
highlight LspReferenceText cterm=none gui=none ctermbg=darkcyan guibg=SkyBlue1 ctermfg=white guifg=black
highlight LspReferenceWrite cterm=none gui=none ctermbg=darkred guibg=darkred ctermfg=white guifg=white
highlight NonText guifg=grey42
highlight Pmenu guibg=grey15
highlight Search guibg=pink guifg=black

if filereadable(expand('$HOME/myconf/local.after.vim'))
    source ~/myconf/local.after.vim
endif

" vim: set et ts=4 sw=4 ss=4 tw=100 :
