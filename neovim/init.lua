local bootstrap = require('core.bootstrap')
bootstrap.setup()
local cfg = bootstrap.local_cfg

require('core.options')
require('core.keymaps')
require('core.autocmds')
if cfg.after_options then
    cfg.after_options()
end

require('core.pack').setup(cfg.packages)
require('theme').setup()
require('lsp').setup()

local utils = require('core.util')
for _, dir in ipairs({ bootstrap.paths.root, bootstrap.paths.local_rt }) do
    local files = vim.fn.glob(dir .. '/lua/setup/*.lua', false, true)
    for _, file in ipairs(files) do
        local specs = dofile(file)
        for _, spec in ipairs(specs) do
            if spec.module == nil then
                -- Own plugin: no try_load, errors must surface
                spec.setup()
            else
                local mod = utils.try_load(spec.module)
                if mod then
                    spec.setup(mod)
                end
            end
        end
    end
end

vim.cmd.source(bootstrap.paths.root .. '/helpers.vim')

vim.cmd('filetype plugin indent on')

if cfg.after_all then
    cfg.after_all()
end

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
