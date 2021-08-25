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
    buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- When LSP starts, configure using table above
nvim_lsp.clangd.setup {
    on_attach = on_attach
}

require'nvim-treesitter.configs'.setup({
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    ensure_installed = {
        "c", "cpp", "rust",
    },
})

-- Useful for inspecting tables
local function describe(symbol, lvl)
    lvl = lvl or 0
    if type(symbol) == 'table' then
        for k, v in pairs(symbol) do
            print(string.rep(' ', lvl * 2) .. '['..k..']=')
            describe(v, lvl + 1)
        end
    elseif symbol == nil then
        print(string.rep(' ', lvl * 2) .. '(nil)')
    else
        print(string.rep(' ', lvl * 2) .. symbol)
    end
end

-- Length of table
local function length(symbol)
    local count = 0
    for _ in pairs(symbol) do
        count = count + 1
    end
    return count
end

local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(function(err, method, result, client_id, _, config)
    local bufnr = vim.uri_to_bufnr(result.uri)
    local errors = {}
    for k, v in pairs(result.diagnostics) do
        errors[k] = {
            filename = vim.uri_to_fname(result.uri),
            text = v.message,
            col = v.range.start.character + 1,
            lnum = v.range.start.line + 1,
        }
    end

    vim.lsp.diagnostic.clear(bufnr, client_id)
    vim.lsp.diagnostic.set_signs(result.diagnostics, bufnr, client_id)
    vim.lsp.util.set_loclist(errors)
end, {})
