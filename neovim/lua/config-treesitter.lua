local utils = require('config-utils')

local function configure_treesitter()
    local treesitter = utils.try_load('nvim-treesitter')
    if treesitter then
        treesitter.install({
            "bash",
            "c",
            "cpp",
            "css",
            "fennel",
            "html",
            "javascript",
            "json",
            "julia",
            "latex",
            "lua",
            "markdown",
            "markdown_inline",
            "norg",
            "python",
            "regex",
            "rust",
            "scss",
            "strace",
            "svelte",
            "tsx",
            "typst",
            "vim",
            "vimdoc",
            "vue",
            "yaml",
        })
    end

    -- Treesitter text objects setup
    local treesitter_textobjects = utils.try_load('nvim-treesitter-textobjects')
    if treesitter_textobjects then
        local select = require('nvim-treesitter-textobjects.select')
        treesitter_textobjects.setup()
        local function create_obj(key, query)
            vim.keymap.set({"x", "o"}, key, function()
                select.select_textobject(query, "textobjects")
            end)
        end
        create_obj("ac", "@comment.outer")
        create_obj("af", "@function.outer")
        create_obj("ai", "@conditional.outer")
        create_obj("al", "@loop.outer")
        create_obj("ao", "@class.outer")
        create_obj("aa", "@parameter.outer")
        create_obj("ia", "@parameter.inner")
        create_obj("ic", "@class.inner")
        create_obj("if", "@function.inner")
        create_obj('la', '@assignment.lhs')
        create_obj('ra', '@assignment.rhs')

        local swap = require('nvim-treesitter-textobjects.swap')
        vim.keymap.set('n', '<leader>a', function()
            swap.swap_next("@parameter.inner")
        end)

        local move = require('nvim-treesitter-textobjects.move')
        local function create_move(key, query)
            vim.keymap.set({'n', 'x', 'o'}, '[' .. key, function()
                move.goto_previous_start(query, 'textobjects')
            end)
            vim.keymap.set({'n', 'x', 'o'}, ']' .. key, function()
                move.goto_next_start(query, 'textobjects')
            end)
        end
        create_move('m', "@function.outer")
        create_move('a', "@parameter.inner")
    end

    local treesitter_context = utils.try_load('treesitter-context')
    _ = treesitter_context and treesitter_context.setup {
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
end

local M = {
    setup = function()
        configure_treesitter()
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
