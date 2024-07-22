local colors = require('color')

-- Symbol highlighting
-- When setting backgrounds, consider looking at HSV color for current background, and only
-- adjust hue, and slightly adjust saturation
-- The current color scheme is based on a background color of #fdf6e3, which would about HSV = 44°, 10%, 99%.
-- The function below uses hue in the range [0,1], instead of [0,360). Given that 44 / 360 = 0.12,
-- we'll use backgrounds with similar lightness and saturation, but shift hue.
--
-- A useful aspect of HSV is that you can find complementary colors by adding 0.5 to the hue, and
-- then remove 1 result  is over 1.

local highligts = {
    -- Treesitter symbols
    ['@class.declaration']      = { both = { bg = 'Purple4' } },
    ['@declaration.identifier'] = { dark = { bg = 'DarkSlateGray' }, light = { bg = 'LightGoldenRod1' } },
    ['@function']               = { dark = { bg = 'Maroon' }, light = { bg = colors.hsv2hex(.9, .1, 1) } },
    ['@function.call']          = { dark = { bg = 'NavyBlue' }, light = { bg = colors.hsv2hex(.55, .1, 1) } },
    ['@method']                 = { dark = { bg = 'Maroon' }, light = { bg = colors.hsv2hex(.36, .1, 1) } },
    ['@note']                   = { light = { bg = colors.hsv2hex(.66, .1, 1) } },
    ['@todo']                   = { light = { bg = colors.hsv2hex(.1, .3, 1), fg = colors.hsv2hex(colors.BLUE, 1, 1) } },
    ['TreesitterContext']       = { light = { bg = colors.hsv2hex(.16, .3, 1) } },
    ['TreesitterContextBottom'] = { both = { underline = true } },
    -- File diffing
    ['DiffAdd']                 = { light = { bg = 'lightblue' } },
    ['DiffChange']              = { light = { bg = 'LightMagenta' } },
    ['DiffText']                = {},
    -- Litee UI
    ['LTSymbol']                = { both = { fg = 'orange', bold = true } },
    ['LTSymbolDetail']          = { light = { fg = 'lightblue' } },
    -- LSP symbol references
    ['LspReferenceRead']        = { both = { bg = 'green', fg = 'white' } },
    ['LspReferenceText']        = { both = { bg = 'SkyBlue1', fg = 'black' } },
    ['LspReferenceWrite']       = { both = { bg = 'darkred', fg = 'white' } },
    -- UI
    ['NonText']                 = { both = { fg = '#bcbcbc', italic = true } },
    ['Pmenu']                   = { dark = { bg = 'grey15' }, light = { bg = '#ffffaf' } },
    ['Search']                  = { both = { bg = 'pink', fg = 'black' } },
    -- Misc
    ['Constant']                = { light = { fg = 'brown', bold = true } },
    ['Number']                  = { light = { fg = 'purple' } },
    ['String']                  = { light = { fg = 'brown', bold = false, italic = true } },
    ['Title']                   = { light = { fg = '#d70000', bold = true } },
}

local M = {
    setup = function()
        -- Apply highlights based on value of g:background, which should be 'light' or 'dark'
        for sym, hl in pairs(highligts) do
            -- merge 'both' with 'light' or 'dark' to create options, allowing background override
            local opt = vim.tbl_extend('force', hl['both'] or {}, hl[vim.g.background] or {})
            vim.api.nvim_set_hl(0, sym, opt)
        end
    end
}

return M
-- vim: set et ts=4 sw=4 ss=4 tw=100 :
