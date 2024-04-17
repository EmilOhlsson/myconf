-- Attempt to load a module, and return nil if doesn't exist
local function try_load(mod_name)
    local ok, result = pcall(require, mod_name)
    if not ok then
        return nil
    end
    return result
end

-- LSP configuration
local nvim_lsp = try_load('lspconfig')
if nvim_lsp ~= nil then
    -- Common LSP handling
    local on_attach = function(_, bufnr)
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

    local servers = { 'clangd', 'pylsp', 'rust_analyzer', 'julials', 'lua_ls', 'vimls' }
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
        --[[ TODO: Check if server is available using
        --if vim.fn.executable('lsp-server-command') then
        --      set up server
        --end
        --]]
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
        icon_set = "simple",
        icon_set_custom = {
            Method = "mf",
            Module = "mod",
        },
        map_resize_keys = false,
        auto_highlight = false,
    }

    litee_lib.setup {
        tree = litee_tree_config,
        panel = {
            panel_size = 60,
        },
    }
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
            "c", "cpp", "glsl", "rust", "lua", "python", "vim", "julia", "fennel"
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

-- TODO: Do we want to do this before setting up LSP, as that also affects highlights
-- Symbol highlighting
-- When setting backgrounds, consider looking at HSV color for current background, and only
-- adjust hue, and slightly adjust saturation
-- The current color scheme is based on a background color of #fdf6e3, which would be 44.10.99 in
-- HSV
local highligts = {
    -- Treesitter symbols
    ['@class.declaration']      = { both = { bg = 'Purple4' } },
    ['@declaration.identifier'] = { dark = { bg = 'DarkSlateGray' }, light = { bg = 'LightGoldenRod1' } },
    ['@function']               = { dark = { bg = 'Maroon' }, light = { bg = '#ffaf00' } },
    ['@function.call']          = { dark = { bg = 'NavyBlue' }, light = { bg = '#dcecf4' } },
    ['@method']                 = { dark = { bg = 'Maroon' }, light = { bg = '#dcf4e0' } },
    ['@note']                   = { light = { bg = '#e3e4fc'} },
    ['@todo']                   = { light = { bg = '#fcdbb0', fg = 'blue' } },
    ['TreesitterContext']       = { light = { bg = '#ffffaf' } },
    ['TreesitterContextBottom'] = { both = { underline = true } },
    -- File diffing
    ['DiffAdd']                 = { light = { bg = 'lightblue' } },
    ['DiffChange']              = { light = { bg = 'LightMagenta' } },
    ['DiffText']                = {},
    -- Litee UI
    ['LTSymbol']                = { both = { fg = 'orange', bold = true } },
    ['LTSymbolDetail']          = { light = { fg = 'lightblue' } },
    -- LSP symbol references
    ['LspReferenceRead']        = { both = { bg = 'green', fg = 'white' } },
    ['LspReferenceText']        = { both = { bg = 'SkyBlue1', fg = 'black' } },
    ['LspReferenceWrite']       = { both = { bg = 'darkred', fg = 'white' } },
    -- UI
    ['NonText']                 = { both = { fg = '#bcbcbc', italic = true } },
    ['Pmenu']                   = { dark = { bg = 'grey15' }, light = { bg = '#ffffaf' } },
    ['Search']                  = { both = { bg = 'pink', fg = 'black' } },
    -- Misc
    ['Constant']                = { light = { fg = 'brown', bold = true } },
    ['Number']                  = { light = { fg = 'purple' } },
    ['String']                  = { light = { fg = 'brown', bold = false, italic = true } },
    ['Title']                   = { light = { fg = '#d70000', bold = true } },
}

-- Apply highlights based on value of g:background, which should be 'light' or 'dark'
for sym, hl in pairs(highligts) do
    -- merge 'both' with 'light' or 'dark' to create options, allowing background override
    local opt = vim.tbl_extend('force', hl['both'] or {}, hl[vim.g.background] or {})
    vim.api.nvim_set_hl(0, sym, opt)
end

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
