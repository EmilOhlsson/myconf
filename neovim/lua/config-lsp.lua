local utils = require('config-utils')

local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function toggle_diagnostics()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function next_diagnostic()
    vim.diagnostic.jump({ count = 1, float = true })
end

local function prev_diagnostic()
    vim.diagnostic.jump({ count = -1, float = true })
end

local function configure_lsp()
    local nvim_lsp = utils.try_load('lspconfig')
    if nvim_lsp ~= nil then
        --[[ NOTE: Neovim 0.11+ has built-in support for project-specific LSP configurations:
                   Create lsp/<server>.lua files in your project root to override these settings.
                   For example: create "lsp/clangd.lua" in your project with custom compiler paths.
                   See :help lsp-quickstart for details.]]--
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local common_config = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- Enable LSP completion with snippet expansion support
                if client:supports_method('textDocument/completion') then
                    vim.lsp.completion.enable(true, client.id, bufnr)
                end
                -- Only configure reference highlight if server supports it
                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
                        callback = function(event)
                            if event.event == "CursorHold" then
                                vim.lsp.buf.document_highlight()
                            else
                                vim.lsp.buf.clear_references()
                            end
                        end
                    })
                end
                local function map(mode, key, cmd, description)
                    vim.keymap.set(mode, key, cmd, {
                        buffer = bufnr,
                        desc = description,
                    })
                end
                -- TODO: Might be worth checking if all of these commands are really relevant
                -- NOTE: Several commands are now set by default. See `:help lsp-defaults`
                local prefix = '\\'
                map('n', prefix .. 'ca', vim.lsp.buf.code_action, "Execute code action")
                map('n', prefix .. 'ds', vim.lsp.buf.document_symbol, "Show symbol documentation")
                map('n', prefix .. 'ee', vim.diagnostic.open_float, "Show line error")
                map('n', prefix .. 'ih', toggle_inlay_hint, "Toggle inlay hints from LSP")
                map('n', prefix .. 'lD', vim.lsp.buf.declaration, "Go to declaration")
                map('n', prefix .. 'ld', vim.lsp.buf.definition, "Go to definition")
                map('n', prefix .. 'le', next_diagnostic, "Go to next error")
                map('n', prefix .. 'lh', vim.lsp.buf.hover, "Show hover information")
                map('n', prefix .. 'li', vim.lsp.buf.implementation, "Go to implementation")
                map('n', prefix .. 'lI', vim.lsp.buf.incoming_calls, "List incoming calls")
                map('n', prefix .. 'lO', vim.lsp.buf.outgoing_calls, "List outgoing calls")
                map('n', prefix .. 'lp', prev_diagnostic, "Go to previous error")
                map('n', prefix .. 'lr', vim.lsp.buf.references, "Jump to next reference")
                map('n', prefix .. 'ls', vim.lsp.buf.signature_help, "Show signature help")
                map('n', prefix .. 'rn', vim.lsp.buf.rename, "Rename symbol")
                map('n', prefix .. 'ws', vim.lsp.buf.workspace_symbol, "Search for workspace symbol")
                map('n', prefix .. 'td', toggle_diagnostics, "Toggle diagnostic hints")
                map('i', '<c-k>', vim.lsp.buf.signature_help, "Show signature help")
                map('i', '<c-h>', vim.lsp.buf.hover, "Show hover information")
            end,
        }

        local server_configs = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = {
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
                    "--query-driver", "/usr/bin/*g++,/usr/bin/*gcc", -- Allow query of some compilers
                    "-j=16",                                         -- Use more threads
                    "--completion-style=bundled",                    -- Include more information
                    "--enable-config",                               -- Allow configuration
                    "--background-index",                            -- Index in background, store to file
                    "--header-insertion=iwyu",                       -- Include what you use
                    "--pch-storage=memory",                          -- Boost perf for precomiled headers
                    "--header-insertion-decorators",                 -- Decorete completions that add headers
                },
            },
            rust_analyzer = {
                cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
            },
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pylint = {
                                enabled = true
                            },
                            pycodestyle = {
                                enabled = true,
                                ignore = 'E501',
                                maxlinelength = 120,
                            },
                        },
                    },
                },
            }
        }

        local servers = { 'clangd', 'pylsp', 'ruff', 'pyright', 'rust_analyzer', 'julials', 'lua_ls', 'bashls' }

        -- Configure each server with the native vim.lsp.config API
        for _, lsp in ipairs(servers) do
            local server_specific_config = server_configs[lsp] or {}
            local final_config = vim.tbl_deep_extend('force', common_config, server_specific_config)
            vim.lsp.config(lsp, final_config)
        end

        -- Enable all configured servers
        for _, lsp in ipairs(servers) do
            vim.lsp.enable(lsp)
        end
    end
end


local M = {
    setup = function()
        configure_lsp()
        vim.diagnostic.config({
            virtual_lines = {
                current_line = true,
            },
        })
        vim.o.winborder = 'rounded'

        -- Snippet navigation is handled by default Neovim 0.11 keybindings:
        -- <Tab> jumps forward, <S-Tab> jumps backward when snippet is active
        -- Snippets are expanded using <c-y>
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
