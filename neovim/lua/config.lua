local nvim_lsp = require('lspconfig')

-- Common LSP handling
local on_attach = function(client, bufnr)
    local function map(mode, key, cmd)
        vim.keymap.set(mode, key, cmd, {
            buffer = bufnr
        })
    end
    map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('i', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('i', '<c-h>', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('v', '<leader>lF', '<cmd>lua vim.lsp.buf.format{async=true}<CR>')
    map('n', '<leader>ee', '<cmd>lua vim.diagnostic.open_float({})<CR>')
    map('n', '<leader>lF', '<cmd>lua vim.lsp.buf.format{async=true}<CR>')
    map('n', '<leader>le', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map('n', '<leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    map('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    map('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n', '<leader>lI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    map('n', '<leader>lO', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- When LSP starts, configure using table above
nvim_lsp.clangd.setup {
    on_attach = on_attach
}

local servers = { 'clangd', 'pylsp', 'rust_analyzer', 'julials', 'lua_ls' }
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
    if lsp == 'lua_ls' then -- Set up for NeoVim plugins
        conf.on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    }
                })

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
        end
    end
    nvim_lsp[lsp].setup(conf)
end

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    on_references, {
        -- Use location list instead of quickfix list
        loclist = true,
    })

local litee_tree_config = {
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
    },
    indent = {
        enable = false,
        disable = {},
    },

    ensure_installed = {
        "c", "cpp", "glsl", "rust", "lua", "python", "vim", "julia"
    },
})

require('gitsigns').setup({
    current_line_blame = true,
    on_attach = function(bufnr)
        local function map(mode, key, cmd)
            vim.keymap.set(mode, key, cmd, {
                buffer = bufnr
            })
        end
        map('n', ']h', '<cmd>lua package.loaded.gitsigns.next_hunk()<CR>')
        map('n', '[h', '<cmd>lua package.loaded.gitsigns.prev_hunk()<CR>')
        map('n', '<leader>hs', '<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>')
        map('n', '<leader>hp', '<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>')
    end,
    preview_config = {
        border = 'shadow',
        style = 'minimal',
    },
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
