local utils = require('config-utils')

local function configure_treesitter()
    -- Treesitter setup
    local treesitter_configs = utils.try_load('nvim-treesitter.configs')
    if treesitter_configs ~= nil then
        treesitter_configs.setup {
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["ac"] = "@comment.outer",
                        ["af"] = "@function.outer",
                        ["ai"] = "@conditional.outer",
                        ["al"] = "@loop.outer",
                        ["ao"] = "@class.outer",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["ic"] = "@class.inner",
                        ["if"] = "@function.inner",
                        ['la'] = '@assignment.lhs',
                        ['ra'] = '@assignment.rhs',
                    },
                },
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[a"] = "@parameter.inner",
                    },
                },
            },
            refactor = {
                highlight_current_scope = {
                    enable = false,
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        -- TODO: document these symbols
                        list_definitions = '<leader>tl',
                        list_definitions_toc = '<leader>ta',
                        goto_next_usage = '<leader>tn',
                        goto_previous_usage = '<leader>tp',
                        goto_definition = '<leader>td',
                    },
                },
            },
            highlight = {
                enable = true,
                disable = {},
            },
            indent = {
                enable = false,
                disable = {},
            },

            ensure_installed = {
                "pioasm", "bash", "c", "cpp", "rust", "lua", "python", "vim", "vimdoc", "json", "julia", "fennel",
                "markdown", "markdown_inline", "strace", "regex",
                "css", "html", "javascript", "latex", "norg", "scss", "svelte", "tsx", "typst", "vue",
            },
        }

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
end

local M = {
    setup = function()
        configure_treesitter()
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
