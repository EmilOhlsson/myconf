local map = require('core.util').map

return {
    {
        module = 'nvim-treesitter',
        setup = function(treesitter)
            treesitter.install({
                'c',
                'cpp',
                'lua',
            })
        end,
    },
    {
        module = 'nvim-treesitter-textobjects',
        setup = function(treesitter_textobjects)
            local select = require('nvim-treesitter-textobjects.select')
            treesitter_textobjects.setup()
            local function create_obj(key, query)
                map({'x', 'o'}, key, function()
                    select.select_textobject(query, 'textobjects')
                end, 'Select ' .. query)
            end
            create_obj('ac', '@comment.outer')
            create_obj('af', '@function.outer')
            create_obj('ai', '@conditional.outer')
            create_obj('al', '@loop.outer')
            create_obj('ao', '@class.outer')
            create_obj('aa', '@parameter.outer')
            create_obj('ia', '@parameter.inner')
            create_obj('ic', '@class.inner')
            create_obj('if', '@function.inner')
            create_obj('il', '@assignment.lhs')
            create_obj('ir', '@assignment.rhs')

            local swap = require('nvim-treesitter-textobjects.swap')
            map('n', '<leader>a', function()
                swap.swap_next('@parameter.inner')
            end, 'Swap parameter with the next one')

            local move = require('nvim-treesitter-textobjects.move')
            local function create_move(key, query)
                map({'n', 'x', 'o'}, '[' .. key, function()
                    move.goto_previous_start(query, 'textobjects')
                end, 'Jump to previous ' .. query)
                map({'n', 'x', 'o'}, ']' .. key, function()
                    move.goto_next_start(query, 'textobjects')
                end, 'Jump to next ' .. query)
            end
            create_move('m', '@function.outer')
            create_move(',', '@parameter.inner')
        end,
    },
    {
        module = 'treesitter-context',
        setup = function(treesitter_context)
            treesitter_context.setup {
                enable = true,
                patterns = {
                    default = {
                        'class',
                        'function',
                        'method',
                        'for',
                        'while',
                        'if',
                        'switch',
                        'case',
                    }
                },
                --separator = '-',
                mode = 'topline',
                min_window_height = 30,
                max_lines = 10,
            }
        end,
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
