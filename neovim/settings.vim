" Termdebug
nnoremap <leader>ds <cmd>Step<CR>
nnoremap <leader>dn <cmd>Over<CR>
nnoremap <leader>df <cmd>Finish<CR>
nnoremap <leader>dc <cmd>Continue<CR>
nnoremap <leader>de <cmd>Evaluate<CR>

" Move lines up and down
nnoremap <S-Up> :move -2<CR>==
nnoremap <S-Down> :move +1<CR>==
vnoremap <S-Up> :move '<-2<CR>gv=gv
vnoremap <S-Down> :move '>+1<CR>gv=gv

" Tab navigation
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>

" Allow location list stepping
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>

" Allow quick fix stepping
nnoremap [c :cprev<CR>
nnoremap ]c :cnext<CR>

" Autocomple on ctrl+space
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" Terminal commands
tnoremap <Esc> <C-\><C-n>

" Build
nnoremap <c-j> :make<CR>

" vim: set et tw=80 ts=4 sw=4 ss=4:
