local nvim_lsp = require('lspconfig')

-- Common LSP handling
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('v', '<leader>lf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.diagnostic.open_float({})<CR>', opts)
    buf_set_keymap('n', '<leader>lF', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>le', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>lI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<leader>lO', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach(client, bufnr)
end

-- When LSP starts, configure using table above
nvim_lsp.clangd.setup {
    on_attach = on_attach
}

local servers = { 'clangd', 'pylsp' , 'rust_analyzer' }
for _, lsp in ipairs(servers) do
    local conf = {
        on_attach = on_attach,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false
                }),
            ["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    --border = "rounded",
                })
        },
    }
    if lsp == 'sumneko_lua' then -- Set up for NeoVim plugins
        conf.settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        }
    end
    nvim_lsp[lsp].setup(conf)
end

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    on_references, {
        -- Use location list instead of quickfix list
        loclist = true,
    })

litee_tree_config = {
        icon_set = "simple",
        icon_set_custom = {
            Method = "mf",
            Module = "mod",
        },
        map_resize_keys = false,
        auto_highlight = false,
    }
require('litee.lib').setup({
        tree = litee_tree_config,
        panel = {
            panel_size = 30,
        },
    })
require('litee.symboltree').setup(litee_tree_config)
require('litee.calltree').setup(litee_tree_config)

require('nvim-treesitter.configs').setup({
        highlight = {
            enable = true,
            disable = {},
            additional_vim_regex_highlighting = true,
        },
        indent = {
            enable = false,
            disable = {},
        },

        ensure_installed = {
            "c", "cpp", "glsl", "rust", "lua", "python", "vim"
        },
    })

require('gitsigns').setup({
        keymaps = {
            noremap = true,
            ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
            ['v <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
            ['n <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
            ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
        },
        current_line_blame = true
    })

require('treesitter-context').setup({
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
        separator = '-',
        mode = 'topline',
    })

require('nvim-treesitter.configs').setup({
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["aa"] = "@parameter.outer",
                ["ac"] = "@comment.outer",
                ["af"] = "@function.outer",
                ["ai"] = "@conditional.outer",
                ["al"] = "@loop.outer",
                ["ao"] = "@class.outer",
                ["ia"] = "@parameter.inner",
                ["if"] = "@function.inner",
                ["io"] = "@class.inner",
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
                list_definitions = '<leader>tl',
                list_definitions_toc = '<leader>ta',
                goto_next_usage = '<leader>tn',
                goto_previous_usage = '<leader>tp',
                goto_definition = '<leader>td',
            },
        },
    },
})

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
