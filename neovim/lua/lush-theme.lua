local lush = require('lush')
local hsl = lush.hsl

-- When editing this file, make sure that you run `:Lushify`, which will make
-- Lush highlight Highlights using their respective color settings, making the
-- editing a kind of a WYSIWYG process
--
--hsl([0-360), [0-100], [0-100]) allow  converting a hsl color to hex

local bg = hsl(44, 87, 94)
local fg = bg.ro(180).lightness(30).saturation(50)
local bg_emp = bg.sa(5).da(5)
local orange = hsl(20, 100, 50)
local brown = orange.da(40)
local purple = hsl(265, 100, 50)

local red = hsl(0, 100, 50)
local green = hsl(120, 100, 50)
local blue = hsl(240, 100, 50)

-- Highlight rules. Uses magic meta functions, so disable certain diagnostics
-- as to not have LSP become angry
---@diagnostic disable: undefined-global
return lush(function(injected)
    local sym = injected.sym
    return {
        -- Basic
        Normal   { fg=fg, bg=bg  },
        String   { fg=brown, gui='italic' },
        Number   { fg=purple },
        Title    { fg=orange, gui='bold'},
        Comment  { fg=bg.lightness(30) },
        Todo     { bg=bg_emp.ro(20), fg=brown },

        Statement   { fg=fg.li(50), gui='bold'},
        Conditional { Statement },
        Identifier  { fg=brown },
        Type        { fg = fg, gui='bold' },

        -- Treesitter symbols
        sym'@class.declaration'      { bg=bg_emp.ro(90) },
        sym'@declaration.identifier' { bg=bg_emp },
        sym'@function'               { bg=bg_emp.ro(120) },
        sym'@function.call'          { bg=bg_emp.hue(190) },
        sym'@method'                 { bg=bg_emp.hue(130) },
        sym'@note'                   { bg=bg_emp.hue(234) },
        sym'@todo'                   { Todo },
        sym'@text.todo'              { Todo },

        -- UI
        Visual                   { bg=bg_emp.da(10).sa(10) },
        CursorLine               { bg=bg_emp.de(50) },
        NonText                  { fg=bg_emp.de(50).mix(hsl(0,0,0), 20), gui='italic' },
        NvimDapVirtualText       { NonText },

        Pmenu                    { bg=bg_emp },
        Search                   { bg=bg_emp.da(30) },
        TreesitterContext        { bg=bg_emp.da(10)  },
        TreesitterContextBottom  { TreesitterContext, gui='underline' },

        -- File diffing
        Changed { bg = bg.hue(240) },
        Added   { bg = bg.hue(120) },
        Removed { bg = bg.hue(0) },

        -- Litee UI
        LTSymbol        { fg = orange, gui='bold' },
        LTSymbolDetail  { fg = bg.mix(blue, 50), gui='italic' },

        -- LSP symbol references
        LspReferenceRead   { bg = green.li(50), fg = green.readable()  },
        LspReferenceText   { bg = blue.li(50), fg = blue.readable() },
        LspReferenceWrite  { bg = red.li(50), fg = red.readable() },
    }
end)

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
