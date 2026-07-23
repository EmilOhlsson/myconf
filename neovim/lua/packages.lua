local M = {}

M.setup = function()
    vim.pack.add({
        -- TODO: Properly understand the current state of treesitter.
        { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = '4916d6592ede8c07973490d9322f187e07dfefac', },
        { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context', version = 'b311b30818951d01f7b4bf650521b868b3fece16', },
        { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = '851e865342e5a4cb1ae23d31caf6e991e1c99f1e', },

        { src = 'https://github.com/lewis6991/gitsigns.nvim', version = 'a462f41' }, -- v2.1.0

	-- Tabularize text, could probably be replaced by something simpler
	{ src = 'https://github.com/godlygeek/tabular.git', version = '12437cd' },

        -- -- TODO: Go through and tag specific commits
        -- Plug 'mfussenegger/nvim-dap'	-- 6a5bba0ddea5d419a783e170c20988046376090d
        -- Plug 'nvim-neotest/nvim-nio'
        -- Plug 'rcarriga/nvim-dap-ui'
        -- Plug 'theHamsta/nvim-dap-virtual-text'
        --
        -- TODO: Clean these up. I don't think these are actually required
	{ src = 'https://github.com/nvim-lua/plenary.nvim', version = '74b06c6c75e4eeb3108ec01852001636d85a932b', }, -- Useful for Shears, but candidate for removal
        { src = 'https://github.com/echasnovski/mini.nvim', version = '1345d191bb3da9c7b0e977f4387c5761f9bff68d', }, -- 0.18 - mini.nvim is a collection of plugins
	{ src = 'https://github.com/folke/snacks.nvim',     version = 'e6fd58c' }, 					     -- 2.31.1 Pickers etc

	-- My own plugins
        { src = 'https://github.com/EmilOhlsson/Highlighter.nvim', },
        { src = 'https://github.com/EmilOhlsson/FloatTerm.nvim', },
        { src = 'https://github.com/EmilOhlsson/Highlighter.nvim', },
        { src = 'https://gitlab.com/EmilOhlsson/shears.nvim', },
    })

    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(event)
            -- TODO:
            -- local name, kind = event.data.spec.name, event.data.kind
            -- if name == 'nvim-treesitter' and kind == 'update' then
            --      if not event.data.active then
            --          vim.cmd.packadd('nvim-treesitter')
            --      end
            --      vim.cmd('TSUpdate')
            -- end
        end,
    })

end


return M
