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
    buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '<leader>lF', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>le', '<cmd>lua vim.diagnostic.goto_next({float = {border = "rounded"}})<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach(client, bufnr)
end

-- When LSP starts, configure using table above
nvim_lsp.clangd.setup {
    on_attach = on_attach
}

local servers = { 'clangd', 'pylsp' , 'rls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false
                }),
			["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					border = "rounded",
				})
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

    ensure_installed = {
        "c", "cpp", "rust", "lua", "python", "vim"
    },
})

local lualine_theme = require('lualine.themes.material-nvim')
lualine_theme.inactive = {}
require('lualine').setup({
    options = {
        theme =  lualine_theme,
        section_separators = '',
        component_separators = '',
        icons_enabled = false,
    },
    sections = {
        lualine_c = {{
            'filename',
            file_status = true,
            path = 1,
        }},
    },
})

local material = require('material')
material.setup({
    contrast = {
        sidebars = true,
        floating = true,
        line_numbers = true,
        sign_column = true,
        non_current_windows = false,
        popup_menu = true,
    },
    custom_highlights = {
        LspReferenceText = {bg = 'lightblue', fg='black'},
        LspReferenceRead = {bg = 'lightgreen', fg='black'},
        LspReferenceWrite = {bg = 'lightred', fg='black'},
        Todo = {bg = 'yellow', fg = 'red'},
        -- StatusLineNC = {bg = 'green'},
        -- StatusLine = {bg = 'yellow'},
    },
})

require('gitsigns').setup({
    keymaps = {
        noremap = true,
        ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
        ['v <leader>hs'] = ':Gitsigns stage_hunk<CR>',
        ['n <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
        ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    },
    current_line_blame = true
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
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ac"] = "@comment.outer",
				["ai"] = "@conditional.outer",
				["al"] = "@loop.outer",
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]m"] = "@function.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
			},
		},
	},
})
