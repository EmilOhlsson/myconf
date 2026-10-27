local utils = require('core.util')

local M = {
    setup = function()
        -- mini-theme needs mini.colors. Without mini.nvim, fall back to plain highlights
        if utils.try_load('mini.colors') then
            require('theme.mini-theme').setup()
        else
            require('theme.fallback').setup()
        end
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
