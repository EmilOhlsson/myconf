-- TODO: A lot of the setup in this file is just plugin setup, so this should probably be renamed
-- TODO: Once v0.12 is release, replace `Plug` with the built in package manager, and replace
-- vim-script files with lua setup

-- Profile startup if `PROF` is set to truthy value
if vim.env.PROF then
    local snacks = vim.fn.stdpath('data') .. '/plugged/snacks.nvim'
    vim.opt.rtp:append(snacks)
    ---@diagnostic disable-next-line: missing-fields
    require('snacks.profiler').startup({
        startup = {
            event = "VimEnter",
        }
    })
end

local utils = require('config-utils')

-- Highlights
local lush = utils.try_load('lush')
if lush then
    lush(require('lush-theme'))
else
    local mini_theme = utils.try_load('mini-theme')
    if mini_theme then
        mini_theme.setup()
    else
        local highlights = utils.try_load('highlights')
        _ = highlights and highlights.setup()
    end
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
            -- TODO: make sure there is a command for showing history
            enabled = true,
            timeout = 10000,
            style = 'fancy',
        }
    })
    vim.keymap.set('n', '<space>ff', snacks.picker.files, {})
    vim.keymap.set('n', '<space>lg', snacks.picker.grep, {})
    vim.keymap.set('n', '<space>fb', snacks.picker.buffers, {})
    vim.keymap.set('n', '<space>fp', snacks.picker.projects, {})
    vim.keymap.set('n', '<space>pp', snacks.picker.pick, {})
    vim.keymap.set('n', '<space>lr', snacks.picker.lsp_references, {})
    vim.keymap.set('n', '<space>gs', snacks.picker.git_status, {})
    -- TODO: For whatever reason, this doesn't work when assigning function here
    vim.keymap.set('n', '<space>dd', ':lua Snacks.picker.todo_comments()<CR>', {})

    -- File explorer
    vim.keymap.set('n', '<c-b>', snacks.picker.explorer, {})
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
        map('n', ';hS', gitsigns.stage_buffer, 'Stage current buffer')
        map('n', ';hr', gitsigns.reset_hunk, 'Reset current hunk')
        map('n', ';hR', gitsigns.reset_buffer, 'Reset current buffer')
        map('n', ';hp', gitsigns.preview_hunk, 'Preview patch from current hunk')
    end,
    preview_config = {
        border = 'rounded',
        style = 'minimal',
    },
}

-- Setup up Floating terminal
local float_term = utils.try_load('FloatTerm')
if float_term ~= nil then
    float_term.setup({
        window_config = {
            border = 'rounded',
        },
    })
    vim.keymap.set('n', '<c-f>', float_term.toggle_window, {
        noremap = true,
        desc = 'Toggle floating terminal',
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

local mini_pairs = utils.try_load('mini.pairs')
if mini_pairs ~= nil then
    mini_pairs.setup()
end

local mini_diff = utils.try_load('mini.diff')
if mini_diff ~= nil then
    mini_diff.setup({
        mappings = {
            apply = ';hs',
            reset = ';hr',
        }
    })
end

-- Misc common setup
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    callback = function(_)
        vim.highlight.on_yank({
            on_visual = false
        })
    end
})

local mini_icons = utils.try_load("mini.icons")
if mini_icons ~= nil then
    mini_icons.setup()
end

local todo_comments = utils.try_load('todo-comments')
if todo_comments ~= nil then
    todo_comments.setup({
        signs = false,
    })
    vim.keymap.set('n', ']d', todo_comments.jump_next, { desc = 'Next todo' })
    vim.keymap.set('n', '[d', todo_comments.jump_prev, { desc = 'Previous todo' })
end

local trouble = utils.try_load('trouble')
if trouble ~= nil then
    trouble.setup({
    })
end

local codecompanion = utils.try_load("codecompanion")
if codecompanion ~= nil then
    local adapters = require("codecompanion.adapters")
    vim.cmd('cab cc CodeCompanion')
    codecompanion.setup({
        adapters = {
            anthropic = function()
                return adapters.extend("anthropic", {
                    name = "My Anthropic interface",
                    env = {
                        -- NOTE: Sometimes there are issues unlocking storage
                        api_key = "cmd:pass show claude/api-key",
                    },
                })
            end,
        },
        strategies = {
            chat = {
                adapter = "anthropic",
                slash_commands = {
                    buffer = {
                        opts = {
                            provider = "snacks",
                        },
                    },
                    file = {
                        opts = {
                            provider = "snacks",
                        },
                    },
                    symbols = {
                        opts = {
                            provider = "snacks",
                        },
                    },
                },
                keymaps = {
                    completion = {
                        modes = {
                            i = "<C-I>",
                        },
                    },
                },
            },
            inline = {
                adapter = "anthropic",
            },
            cmd = {
                adapter = "anthropic",
            },
        },
        opts = {
            --log_level = "TRACE"
        },
    })
end

local render_markdown = utils.try_load('render-markdown')
if render_markdown ~= nil then
    render_markdown.setup({
        bullet = {
            render_modes = false,
        },
    })
end

if vim.fn.has('nvim-0.12') == 1 then
    vim.o.diffopt = 'internal,filler,closeoff,inline:word,linematch:40'
elseif vim.fn.has('nvim-0.11') == 1 then
    vim.o.diffopt = 'internal,filler,closeoff,linematch:40'
end

-- Read skeleton files when available
local skel_group = vim.api.nvim_create_augroup('skeletons', {clear=true})
vim.api.nvim_create_autocmd({'BufNewFile'}, {
    group = skel_group,
    pattern = { '*.*' },
    callback = function(env)
        local ext = vim.fn.expand('%:e')
        if vim.fn.line('$') > 1 or vim.fn.getline(1) ~= '' or ext == '' then
            return
        end

        -- Construct template path
        local rtp = vim.api.nvim_list_runtime_paths()[1]
        local template_path = rtp .. '/templates/skeleton.' .. ext
        if vim.fn.filereadable(template_path) == 0 then
            return
        end

        -- Read template content
        local template_lines = vim.fn.readfile(template_path)

        -- Insert template content into buffer
        vim.api.nvim_buf_set_lines(env.buf, 0, -1, false, template_lines)

        -- Move cursor to first line
        local win = vim.fn.bufwinid(env.buf)
        if win ~= -1 then
            vim.api.nvim_win_set_cursor(win, { 1, 0 })
        end
    end,
})

vim.o.guicursor = 'i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150'

-- TODO: Create function for yanking file name and line range, as to easily be able
-- to give to prompt
-- local start_line = vim.fn.getpos("'<")[2]
-- local path = vim.fn.expand("%")
-- vim.fn.setreg("+", result)

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
