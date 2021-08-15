local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
end

nvim_lsp.clangd.setup {
	on_attach = on_attach
}

require'nvim-treesitter.configs'.setup {
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
}

-- Configure how to handle the published diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		virtual_text = false,
	}
)
