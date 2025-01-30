local utils = require('config-utils')


local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function configure_lsp()
    local nvim_lsp = utils.try_load('lspconfig')
    if nvim_lsp ~= nil then
        local servers = { 'clangd', 'pylsp', 'rust_analyzer', 'julials', 'lua_ls', 'bashls' }
        for _, lsp in ipairs(servers) do
            local common_conf = {
                on_attach = function(_, bufnr)
                    local function map(mode, key, cmd, description)
                        vim.keymap.set(mode, '\\' .. key, cmd, {
                            buffer = bufnr,
                            desc = description,
                        })
                    end
                    -- TODO: Might be worth checking if all of these commands are really relevant
                    map('n', 'ca', vim.lsp.buf.code_action, "Execute code action")
                    map('n', 'ds', vim.lsp.buf.document_symbol, "Show symbol documentation")
                    map('n', 'ee', vim.diagnostic.open_float, "Show line error")
                    map('n', 'ih', toggle_inlay_hint, "Toggle inlay hints from LSP")
                    map('n', 'lD', vim.lsp.buf.declaration, "Go to declaration")
                    map('n', 'ld', vim.lsp.buf.definition, "Go to definition")
                    map('n', 'le', vim.diagnostic.goto_next, "Go to next error")
                    map('n', 'lh', vim.lsp.buf.hover, "Show hover information")
                    map('n', 'li', vim.lsp.buf.implementation, "Go to implementation")
                    map('n', 'lI', vim.lsp.buf.incoming_calls, "List incoming calls")
                    map('n', 'lO', vim.lsp.buf.outgoing_calls, "List outgoing calls")
                    map('n', 'lp', vim.diagnostic.goto_prev, "Go to previous error")
                    map('n', 'lr', vim.lsp.buf.references, "Jump to next reference")
                    map('n', 'ls', vim.lsp.buf.signature_help, "Show signature help")
                    map('n', 'rn', vim.lsp.buf.rename, "Rename symbol")
                    map('n', 'ws', vim.lsp.buf.workspace_symbol, "Search for workspace symbol")
                    map('i', '<c-k>', vim.lsp.buf.signature_help, "Show signature help")
                    map('i', '<c-h>', vim.lsp.buf.hover, "Show hover information")
                end,
                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(
                        vim.lsp.diagnostic.on_publish_diagnostics, {
                            virtual_text = false
                        }),
                },
            }

            --[[ TODO: Move symbol usage highlighting here. (autocmd in init.vim) ]]--
            --[[ TODO: There is support for doing lazy loading of configuration,
            --         which makes it easier to set up project local settings ]]--
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
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--query-driver", "/usr/bin/*g++,/usr/bin/*gcc",    -- Allow query of some compilers
                        "-j=16",                                            -- Use more threads
                        "--completion-style=bundled",                       -- Include more information
                        "--enable-config",                                  -- Allow configuration
                        "--background-index",                               -- Index in background, store to file
                        "--header-insertion=iwyu",                          -- Include what you use
                        "--pch-storage=memory",                             -- Boost perf for precomiled headers
                        "--header-insertion-decorators",                    -- Decorete completions that add headers
                },
                },
                rust_analyzer = {
                    cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
                },
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pylint = { enabled = true },
                                pycodestyle = {
                                    enabled = true,
                                    maxlinelength = 120,
                                },
                            },
                        },
                    },
                }
            }
            local conf = vim.tbl_deep_extend('force', common_conf, server_configs[lsp] or {})
            nvim_lsp[lsp].setup(conf)
        end

        local on_references = vim.lsp.handlers["textDocument/references"]
        vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
            on_references, {
                -- Use location list instead of quickfix list
                loclist = true,
            })
    end
end


local M = {
    setup = function()
        configure_lsp()
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
