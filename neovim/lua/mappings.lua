local function map(mode, lhs, rhs, description)
    vim.keymap.set(mode, lhs, rhs, { desc = description })
end

-- Termdebug
map('n', '<leader>ds', '<cmd>Step<CR>', 'Debug: step into')
map('n', '<leader>dn', '<cmd>Over<CR>', 'Debug: step over')
map('n', '<leader>df', '<cmd>Finish<CR>', 'Debug: finish')
map('n', '<leader>dc', '<cmd>Continue<CR>', 'Debug: continue')
map('n', '<leader>de', '<cmd>Evaluate<CR>', 'Debug: evaluate expression')

-- Move lines up and down
map('n', '<S-Up>', ':move -2<CR>==', 'Move line up')
map('n', '<S-Down>', ':move +1<CR>==', 'Move line down')
map('v', '<S-Up>', ":move '<-2<CR>gv=gv", 'Move selection up')
map('v', '<S-Down>', ":move '>+1<CR>gv=gv", 'Move selection down')

-- Tab navigation
map('n', '[t', ':tabprevious<CR>', 'Previous tab')
map('n', ']t', ':tabnext<CR>', 'Next tab')

-- Allow location list stepping
map('n', '[l', ':lprev<CR>', 'Previous location list entry')
map('n', ']l', ':lnext<CR>', 'Next location list entry')

-- Allow quick fix stepping
map('n', '[c', ':cprev<CR>', 'Previous quickfix entry')
map('n', ']c', ':cnext<CR>', 'Next quickfix entry')

-- Autocomplete on ctrl+space
map('i', '<C-Space>', '<C-x><C-o>', 'Trigger omni-completion')
map('i', '<C-@>', '<C-Space>', 'Trigger omni-completion (terminal Ctrl-Space)')

-- Terminal commands
map('t', '<Esc>', [[<C-\><C-n>]], 'Exit terminal mode')

-- Build
map('n', '<c-j>', ':make<CR>', 'Run :make')

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
