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
    buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach(client, bufnr)
end

-- When LSP starts, configure using table above
nvim_lsp.clangd.setup {
    on_attach = on_attach
}

local servers = { 'clangd', 'pylsp' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false
                }),
        }
    }
end

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
  on_references, {
    -- Use location list instead of quickfix list
    loclist = true,
  }
)

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

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    ensure_installed = {
        "c", "cpp", "rust", "lua", "python"
    },
})

---- Useful for inspecting tables
--local function describe(symbol, lvl)
--    lvl = lvl or 0
--    if type(symbol) == 'table' then
--        for k, v in pairs(symbol) do
--            print(string.rep(' ', lvl * 2) .. '['..k..']=')
--            describe(v, lvl + 1)
--        end
--    elseif symbol == nil then
--        print(string.rep(' ', lvl * 2) .. '(nil)')
--    else
--        print(string.rep(' ', lvl * 2) .. symbol)
--    end
--end
--
---- Length of table
--local function length(symbol)
--    local count = 0
--    for _ in pairs(symbol) do
--        count = count + 1
--    end
--    return count
--end
--
--local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
--vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(function(err, method, result, client_id, _, config)
--    local bufnr = vim.uri_to_bufnr(result.uri)
--    local errors = {}
--    for k, v in pairs(result.diagnostics) do
--        errors[k] = {
--            filename = vim.uri_to_fname(result.uri),
--            text = v.message,
--            col = v.range.start.character + 1,
--            lnum = v.range.start.line + 1,
--        }
--    end
--
--    vim.lsp.diagnostic.clear(bufnr, client_id)
--    vim.lsp.diagnostic.set_signs(result.diagnostics, bufnr, client_id)
--    vim.lsp.util.set_loclist(errors)
--end, {})

