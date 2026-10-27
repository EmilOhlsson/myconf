--[[ NOTE: Server configs live in lsp/<server>.lua (and local/lsp/ for this machine only). Every
           server with a file there is enabled.

           Project-specific settings go in a trusted .nvim.lua in the project root ('exrc' is on),
           calling vim.lsp.config('<server>', { ... }), which is deep-merged on top of these. A
           project's own lsp/<server>.lua is only read if the project dir is on 'runtimepath'.
           See :help lsp-config-merge and :help lsp-quickstart for details.]]--

local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function toggle_diagnostics()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function toggle_virtual_diagnostic()
    local has_virtual_lines = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = not has_virtual_lines
    })
end

local function next_diagnostic()
    vim.diagnostic.jump({ count = 1, float = true })
end

local function prev_diagnostic()
    vim.diagnostic.jump({ count = -1, float = true })
end

local function on_attach(client, bufnr)
    -- Enable LSP completion with snippet expansion support
    if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, bufnr)
    end
    -- Only configure reference highlight if server supports it
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorMoved' }, {
            buffer = bufnr,
            callback = function(event)
                if event.event == 'CursorHold' then
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
    map('n', '[e', prev_diagnostic, 'Go to previous error')
    map('n', ']e', next_diagnostic, 'Go to next error')
    map('n', prefix .. 'ca', vim.lsp.buf.code_action, 'Execute code action')
    map('n', prefix .. 'ds', vim.lsp.buf.document_symbol, 'Show symbol documentation')
    map('n', prefix .. 'ee', vim.diagnostic.open_float, 'Show line error')
    map('n', prefix .. 'ih', toggle_inlay_hint, 'Toggle inlay hints from LSP')
    map('n', prefix .. 'lD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', prefix .. 'ld', vim.lsp.buf.definition, 'Go to definition')
    map('n', prefix .. 'lh', vim.lsp.buf.hover, 'Show hover information')
    map('n', prefix .. 'li', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', prefix .. 'lI', vim.lsp.buf.incoming_calls, 'List incoming calls')
    map('n', prefix .. 'lO', vim.lsp.buf.outgoing_calls, 'List outgoing calls')
    map('n', prefix .. 'lr', vim.lsp.buf.references, 'Jump to next reference')
    map('n', prefix .. 'ls', vim.lsp.buf.signature_help, 'Show signature help')
    map('n', prefix .. 'rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', prefix .. 'ws', vim.lsp.buf.workspace_symbol, 'Search for workspace symbol')
    map('n', prefix .. 'td', toggle_diagnostics, 'Toggle diagnostic hints')
    map('n', prefix .. 'tv', toggle_virtual_diagnostic, 'Toggle diagnostic virtual text')
    map('i', '<c-k>', vim.lsp.buf.signature_help, 'Show signature help')
    map('i', '<c-h>', vim.lsp.buf.hover, 'Show hover information')
end

local M = {
    setup = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                on_attach(client, args.buf)
            end,
        })

        local paths = require('core.bootstrap').paths
        local servers = {}
        for _, dir in ipairs({ paths.root, paths.local_rt }) do
            local files = vim.fn.glob(dir .. '/lsp/*.lua', false, true)
            for _, file in ipairs(files) do
                local name = vim.fn.fnamemodify(file, ':t:r')
                servers[name] = true
            end
        end
        -- TODO: No server sets root_markers, so clients start without a root dir. That's probably
        --       why lua_ls in the editor ignores .luarc.json
        vim.lsp.enable(vim.tbl_keys(servers))

        -- Snippet navigation is handled by default Neovim 0.11 keybindings:
        -- <Tab> jumps forward, <S-Tab> jumps backward when snippet is active
        -- Snippets are expanded using <c-y>
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
