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
        local function map(mode, key, cmd, description)
            vim.keymap.set(mode, key, cmd, {
                buffer = bufnr,
                desc = description
            })
        end
        map('n', ']h', gitsigns.next_hunk, 'Jump to next changed hunk')
        map('n', '[h',  gitsigns.prev_hunk, 'Jump to previos changed hunk')
        map('n', ';hs', gitsigns.stage_hunk, 'Stage current hunk')
        map('n', ';hr', gitsigns.reset_hunk, 'Reset current hunk')
        map('n', ';hp', gitsigns.preview_hunk, 'Preview patch from current hunk')
    end,
    preview_config = {
        border = 'shadow',
        style = 'minimal',
    },
}

-- Setup up Floating terminal
local float_term = utils.try_load('FloatTerm')
if float_term ~= nil then
    float_term.setup()
    vim.keymap.set('n', '<c-f>', float_term.toggle_window, {
        noremap = true,
        desc = 'Toggle floating terminal'
    })
end

-- Configure highlighter
local highlighter = utils.try_load('Highlighter')
if highlighter ~= nil then
    highlighter.setup()
    vim.keymap.set('n', '<c-h>', ':Highlighter<cr>', {
        noremap = true,
        desc = 'Highlight current symbol',
    })
end

-- Setup Mini plugins
local mini_surround = utils.try_load('mini.surround')
if mini_surround ~= nil then
    mini_surround.setup()
end

-- Misc common setup
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    callback = function(_)
        vim.highlight.on_yank({
            on_visual = false
        })
    end
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "auto"
vim.opt.foldnestmax = 4
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''

local web_devicons = utils.try_load("nvim-web-devicons")
if web_devicons ~= nil then
    web_devicons.setup({
    })
end

local snacks = utils.try_load('snacks')
if snacks ~= nil then
    snacks.setup({
        bigfile = {},
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
            statuscolumn = {
            },
        },
        picker = {
            layout = 'telescope',
        },
        notifier = {
            enabled = true,
        }
    })
    vim.keymap.set('n', '<space>ff', snacks.picker.files, {})
    vim.keymap.set('n', '<space>lg', snacks.picker.grep, {})
    vim.keymap.set('n', '<space>fb', snacks.picker.buffers, {})
    vim.keymap.set('n', '<space>fp', snacks.picker.projects, {})
    vim.keymap.set('n', '<space>pp', snacks.picker.pick, {})
    vim.keymap.set('n', '<space>lr', snacks.picker.lsp_references, {})

    -- File explorer
    vim.keymap.set('n', '<c-b>', snacks.picker.explorer, {})
end

local todo_comments = utils.try_load('todo-comments')
if todo_comments ~= nil then
    todo_comments.setup({
    })
end

local trouble = utils.try_load('trouble')
if trouble ~= nil then
    trouble.setup({
    })
end

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
