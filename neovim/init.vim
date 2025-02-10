set rtp^=$HOME/myconf/neovim rtp+=$HOME/myconf/neovim/after
let &packpath = &runtimepath

" Make sure that we're aware of the color theme
let g:background=expand('$BACKGROUND')
if g:background == 'light'
    set background=light
else
    set background=dark
    let g:background='dark'
endif

if filereadable(expand('$HOME/myconf/local.vim'))
    source ~/myconf/local.vim
endif

source ~/myconf/neovim/plugins.vim
source ~/myconf/neovim/settings.vim
source ~/myconf/neovim/helpers.vim

if has('nvim')
  lua require('config')
endif

filetype plugin indent on

if filereadable(expand('$HOME/myconf/local.after.vim'))
    source ~/myconf/local.after.vim
endif

" vim: set et ts=4 sw=4 ss=4 tw=100 :
