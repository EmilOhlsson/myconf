set rtp^=$HOME/myconf/neovim

if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif

source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('config')
endif

autocmd CursorHold * lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * lua vim.lsp.buf.clear_references()
autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}

filetype plugin indent on
colorscheme koehler

set cursorline

" TODO: This would probably be more convient with some kind of Lua table setup
highlight CursorLine guibg=grey20
highlight Cursorline gui=none cterm=none ctermbg=darkgrey
highlight DiffAdd cterm=none ctermbg=lightblue
highlight DiffChange cterm=none ctermbg=LightMagenta
highlight DiffText cterm=none ctermbg=LightCyan
highlight LspReferenceRead cterm=none gui=none ctermbg=darkgreen guibg=green ctermfg=white guifg=white
highlight LspReferenceText cterm=none gui=none ctermbg=darkcyan guibg=blue ctermfg=white guifg=white
highlight LspReferenceWrite cterm=none gui=none ctermbg=darkred guibg=darkred ctermfg=white guifg=white
highlight NonText guifg=grey42
highlight Pmenu guibg=grey15
highlight Search guibg=pink guifg=black
highlight @function.call guibg=NavyBlue
highlight @declaration.identifier guibg=DarkSlateGray
" TODO: Maybe link with Identifier
highlight LTSymbol guifg=orange gui=bold
" TODO Maybe link with Comment
highlight LTSymbolDetail guifg=lightblue

" vim: set et tw=80:
