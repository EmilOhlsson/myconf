-- Attempt to load a module, and return nil if doesn't exist
local function try_load(mod_name)
    local ok, result = pcall(require, mod_name)
    if not ok then
        return nil
    end
    return result
end

-- Highlights
local lush = try_load('lush')
if lush then
    lush(require('lush-theme'))
else
    local highlights = try_load('highlights')
    _ = highlights and highlights.setup()
end

-- LSP configuration
local nvim_lsp = try_load('lspconfig')
if nvim_lsp ~= nil then
    local servers = { 'clangd', 'pylsp', 'rust_analyzer', 'julials', 'lua_ls' }
    for _, lsp in ipairs(servers) do
        local common_conf = {
            on_attach = function(_, bufnr)
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
                vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {})
            end,
            handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = false
                    }),
            },
        }

        local server_configs = {
            lua_ls = {
                settings = {
                    Lua = {
                        settings = {
                            version = 'LuaJIT',
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true)
                        },
                    },
                }
            }
        }
        local conf = vim.tbl_deep_extend('force', common_conf, server_configs[lsp] or {})
        --print('Configuring ' .. lsp .. ' with ' .. vim.inspect(conf))
        nvim_lsp[lsp].setup(conf)
    end

    local on_references = vim.lsp.handlers["textDocument/references"]
    vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
        on_references, {
            -- Use location list instead of quickfix list
            loclist = true,
        })
end

-- Litee setup
local litee_lib = try_load('litee.lib')
if litee_lib ~= nil then
    local litee_tree_config = {
        icon_set = "codicons",
        --icon_set_custom = {
        --    Method = "mf",
        --    Module = "mod",
        --},
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
    local litee_symboltree = try_load('litee.symboltree').setup(litee_tree_config)
    local litee_calltree = try_load('litee.calltree').setup(litee_tree_config)
    _ = litee_symboltree and litee_symboltree.setup(litee_tree_config)
    _ = litee_calltree and litee_calltree.setup(litee_tree_config)
end

-- Treesitter setup
local treesitter_configs = try_load('nvim-treesitter.configs')
if treesitter_configs ~= nil then
    treesitter_configs.setup {
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
        highlight = {
            enable = true,
            disable = {},
        },
        indent = {
            enable = false,
            disable = {},
        },

        ensure_installed = {
            "c", "cpp", "glsl", "rust", "lua", "python", "vim", "vimdoc", "julia", "fennel", "markdown"
        },
    }

    local treesitter_context = try_load('treesitter-context')
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

-- Gitsigns
local gitsigns = try_load('gitsigns')
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
        map('n', '<leader>hs', '<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>')
        map('n', '<leader>hr', '<cmd>lua package.loaded.gitsigns.reset_hunk()<CR>')
        map('n', '<leader>hp', '<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>')
    end,
    preview_config = {
        border = 'shadow',
        style = 'minimal',
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
