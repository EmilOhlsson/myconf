local utils = require('config-utils')

-- Highlights
local lush = utils.try_load('lush')
if lush then
    lush(require('lush-theme'))
else
    local highlights = utils.try_load('highlights')
    _ = highlights and highlights.setup()
end

-- LSP
local config_lsp = utils.try_load('config-lsp')
if config_lsp ~= nil then
    config_lsp.setup()
end

-- Treesitter
local config_treesitter = utils.try_load('config-treesitter')
if config_treesitter ~= nil then
    config_treesitter.setup()
end

-- Configure debug adapter
local dap_config = require('config-dap')
dap_config.setup()

-- Litee setup
local litee_lib = utils.try_load('litee.lib')
if litee_lib ~= nil then
    local litee_tree_config = {
        icon_set = "codicons",
        map_resize_keys = false,
        auto_highlight = false,
    }

    litee_lib.setup({
        tree = litee_tree_config,
        panel = {
            panel_size = 60,
        },
    })
    -- TODO: Configure colors, and make sure to expand incoming calls if there is space
    local litee_symboltree = utils.try_load('litee.symboltree').setup(litee_tree_config)
    local litee_calltree = utils.try_load('litee.calltree').setup(litee_tree_config)
    _ = litee_symboltree and litee_symboltree.setup(litee_tree_config)
    _ = litee_calltree and litee_calltree.setup(litee_tree_config)
end

-- Gitsigns
local gitsigns = utils.try_load('gitsigns')
_ = gitsigns and gitsigns.setup {
    current_line_blame = true,
    on_attach = function(bufnr)
        local function map(mode, key, cmd)
            vim.keymap.set(mode, key, cmd, {
                buffer = bufnr
            })
        end
        map('n', ']h', '<cmd>lua package.loaded.gitsigns.next_hunk()<CR>')
        map('n', '[h', '<cmd>lua package.loaded.gitsigns.prev_hunk()<CR>')
        map('n', ';hs', '<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>')
        map('n', ';hr', '<cmd>lua package.loaded.gitsigns.reset_hunk()<CR>')
        map('n', ';hp', '<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>')
    end,
    preview_config = {
        border = 'shadow',
        style = 'minimal',
    },
}

-- Telescope
local telescope = utils.try_load('telescope')
if telescope ~= nil then
    telescope.setup()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<space>ff', builtin.find_files, {})
    vim.keymap.set('n', '<space>gf', builtin.git_files, {})
    vim.keymap.set('n', '<space>lg', builtin.live_grep, {})
    vim.keymap.set('n', '<space>fb', builtin.buffers, {})
    vim.keymap.set('n', '<space>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<space>qf', builtin.quickfix, {})
    vim.keymap.set('n', '<space>ic', builtin.lsp_incoming_calls, {})
    vim.keymap.set('n', '<space>lb', builtin.builtin, {})
end

-- Setup up Floating terminal
local float_term = utils.try_load('FloatTerm')
if float_term ~= nil then
    float_term.setup()
    vim.keymap.set('n', '<c-f>', float_term.toggle_window, {
        noremap = true,
        desc = 'Toggle floating terminal'
    })
end

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
