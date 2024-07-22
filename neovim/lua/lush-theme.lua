local lush = require('lush')
local hsl = lush.hsl

--
--hsl([0-360), [0-100], [0-100]) allow  converting a hsl color to hex

local bg = hsl(44, 87, 94)
local fg = bg.ro(180).lightness(30).saturation(50)
local bg_emp = bg.sa(5).da(5)
local orange = hsl(20, 100, 50)
local brown = orange.da(40)
local purple = hsl(265, 100, 50)

-- TODO: Replace named colors with HSL calls
-- TODO: Create a few primary colors, and then base UI on these colors

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

        Statement { fg=fg.li(50), gui='bold'},
        Conditional { Statement },
        Identifier { fg=brown },
        Type { fg = fg, gui='bold' },

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
        CursorLine               { bg=bg_emp.de(50) },
        NonText                  { bg=bg_emp.de(50), fg=bg_emp.de(50).da(15), gui='italic' },
        Pmenu                    { bg=bg_emp },
        Search                   { bg='Pink', fg='black'},
        TreesitterContext        { bg=bg_emp.da(10)  },
        TreesitterContextBottom  { gui='underline' },

        -- File diffing
        DiffAdd      { bg = 'lightblue'  },
        DiffChange   { bg = 'LightMagenta'  },
        DiffText     {},
        GitSignsAdd  { DiffAdd },

        -- Litee UI
        LTSymbol        { fg = 'orange', gui='bold' },
        LTSymbolDetail  { fg = 'lightblue' },

        -- LSP symbol references
        LspReferenceRead   { bg = 'green', fg = 'white'  },
        LspReferenceText   { bg = 'SkyBlue1', fg = 'black' },
        LspReferenceWrite  { bg = 'darkred', fg = 'white' },
    }
end)

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
