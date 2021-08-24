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

-- Configure how to handle the published diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		virtual_text = false,
	}
)

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

local function length(symbol)
    local count = 0
    for _ in pairs(symbol) do
        count = count + 1
    end
    return count
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, _, result, _)
    local uri = result.uri
    local bufnr = vim.uri_to_bufnr(uri)
    local diagnostics = result.diagnostics
    --if not bufnr then
    --    print("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
    --    return
    --end
    --for _, v in ipairs(diagnostics) do
    --    v.uri = v.uri or result.uri
    --end
    local filtered_diagnostics = {}
    for k, v in pairs(diagnostics) do
        if v.uri then
            filtered_diagnostics[k] = v
        end
    end
    print("Aaarh?")
    print("Diagnostics")
    describe(diagnostics)
    print("done")
    -- This line down here breaks because URI is not always set
    local locations = vim.lsp.util.locations_to_items(filtered_diagnostics)
    print("Locatinos")
    describe(locations)
    vim.lsp.util.set_loclist(locations)
    describe(diagnostics)
    if not diagnostics then
        print("Diagnostics is nil")
    else
        print("Actually have diagnostics: %", length(diagnostics))
    end
    -- This doesn't seem to do anything
    vim.lsp.diagnostic.clear(bufnr, nil, nil, nil)
    vim.lsp.diagnostic.set_signs(diagnostics, bufnr, nil, nil, nil)
end
