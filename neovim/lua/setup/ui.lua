local map = require('core.util').map

return {
    {
        module = 'snacks',
        setup = function(snacks)
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
            })
            map('n', '<space>bd', snacks.picker.diagnostics_buffer, 'Pick: buffer diagnostics')
            map('n', '<space>fb', snacks.picker.buffers, 'Pick: buffers')
            map('n', '<space>fk', snacks.picker.keymaps, 'Pick: keymaps')
            map('n', '<space>ff', snacks.picker.files, 'Pick: file finder')
            map('n', '<space>lg', snacks.picker.grep, 'Pick: live grep')
            map('n', '<space>ll', snacks.picker.loclist, 'Pick: loc list')
            map('n', '<space>lr', snacks.picker.lsp_references, 'Pick: LSP references')
            map('n', '<space>pp', snacks.picker.pick, 'Pick: pickers')
            map('n', '<space>qf', snacks.picker.qflist, 'Pick: quickfix list')
        end,
    },
    {
        module = 'FloatTerm',
        setup = function(float_term)
            float_term.setup({
                window_config = {
                    border = 'rounded',
                },
            })
            map('n', '<c-f>', float_term.toggle_window, 'Toggle floating terminal')
        end,
    },
    {
        -- TODO: Highlighter.nvim requires lush, which isn't installed, so this is always skipped
        module = 'Highlighter',
        setup = function(highlighter)
            highlighter.setup()
            map('n', '<c-h>', ':Highlighter<cr>', 'Highlight current symbol')
        end,
    },
    {
        module = 'mini.surround',
        setup = function(mini_surround)
            mini_surround.setup()
        end,
    },
    {
        module = 'mini.icons',
        setup = function(mini_icons)
            mini_icons.setup()
        end,
    },
    {
        module = 'mini.notify',
        setup = function(mini_notify)
            mini_notify.setup()
            map('n', '<space>nh', mini_notify.show_history, 'Notify: show history')
        end,
    },
    {
        module = 'render-markdown',
        setup = function(render_markdown)
            render_markdown.setup({
                latex = { enabled = true, },
                bullet = { enabled = false, },
                checkbox = { enabled = false, },
                code = { sign = false, },
                heading = { sign = false, },
            })
            map('n', '<leader>rt', function()
                render_markdown.toggle()
            end, 'Markdown: toggle rendering')
        end,
    },
    {
        setup = function()
            require('plugins.smart-yank').setup({
                relative_path = true,
            })
        end,
    },
    {
        setup = function()
            require('plugins.visual-match').setup()
        end,
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
