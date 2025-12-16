local lush = require('lush')
local hsl = lush.hsl

-- When editing this file, make sure that you run `:Lushify`, which will make
-- Lush highlight Highlights using their respective color settings, making the
-- editing a kind of a WYSIWYG process
--
--hsl([0-360), [0-100], [0-100]) allow  converting a hsl color to hex

local red = hsl(0, 100, 50)
local green = hsl(120, 100, 50)
local blue = hsl(240, 100, 50)
local orange = hsl(20, 100, 50)
local purple = hsl(265, 100, 50)
local brown = orange.da(40)

local bg = hsl(44, 87, 94)
local fg = bg.ro(180).lightness(30).saturation(50)
local bg_emp = bg.sa(5).da(5)
local bg_cul = bg_emp.de(50)
local toolbar = '#eef1f8'

-- Base colors for highlighting changes
local added = bg.hue(120)
local changed = bg.hue(240)
local removed = bg.hue(0)

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
        CursorLine               { bg=bg_cul },
        NonText                  { fg=bg_emp.de(50).mix(hsl(0,0,0), 20), gui='italic' },
        NvimDapVirtualText       { NonText },

        -- DAP look
        DapBreakpoint            { fg=red },
        DapBreakpointLine        { bg=red.mix(bg, 80) },
        DapBreakpointCurrentLine { DapBreakpoint, gui='bold' },
        DapStopped               { fg=green.da(40) },
        DapStoppedLine           { bg=green.mix(bg, 80) },
        DapStoppedCurrentLine    { DapStopped, gui='bold' },

        -- DAP UI
        DapUIBreakpointsCurrentLine { fg=green.da(40),gui='bold' },
        DapUIBreakpointsInfo        { fg=green.da(40) },
        DapUIBreakpointsPath        { fg=blue.da(40) },
        DapUIDecoration             { fg=blue.da(40) },
        DapUIFloatBorder            { fg=blue.da(40) },
        DapUILineNumber             { fg=blue.da(40) },
        DapUIModifiedValue          { fg=blue.da(40),gui='bold' },
        DapUIPlayPause              { fg=green.da(40) },
        DapUIPlayPauseNC            { fg=green.da(40),bg=toolbar },
        DapUIRestart                { fg=green.da(40) },
        DapUIRestartNC              { fg=green.da(40),bg=toolbar },
        DapUIScope                  { fg=blue.da(40) },
        DapUIStepBack               { fg=blue.da(40) },
        DapUIStepBackNC             { fg=blue.da(40),bg=toolbar },
        DapUIStepInto               { fg=blue.da(40) },
        DapUIStepIntoNC             { fg=blue.da(40),bg=toolbar },
        DapUIStepOut                { fg=blue.da(40) },
        DapUIStepOutNC              { fg=blue.da(40),bg=toolbar },
        DapUIStepOver               { fg=blue.da(40) },
        DapUIStepOverNC             { fg=blue.da(40),bg=toolbar },
        DapUIStoppedThread          { fg=blue.da(40) },
        DapUIThread                 { fg=green.da(40) },
        DapUIWatchesValue           { fg=green.da(40) },
        DapUIWinSelect              { fg=blue.da(40),gui='bold' },

        Pmenu                    { bg=bg_emp },
        Search                   { bg=bg_emp.da(30) },
        TreesitterContext        { bg=bg_emp.da(10)  },
        TreesitterContextBottom  { TreesitterContext, gui='underline' },

        -- File diffing
        Changed { bg = changed },
        Added   { bg = added },
        Removed { bg = removed },

        -- Litee UI
        LTSymbol        { fg = orange, gui='bold' },
        LTSymbolDetail  { fg = bg.mix(blue, 50), gui='italic' },

        -- LSP symbol references
        LspReferenceRead   { bg=green.li(50), fg=green.readable()  },
        LspReferenceText   { bg=blue.li(50), fg=blue.readable() },
        LspReferenceWrite  { bg=red.li(50), fg=red.readable() },

        -- Gitsigns
        GitSignsAdd             { bg=added.da(20) },
        GitSignsChange          { bg=changed.da(20) },
        GitSignsDelete          { bg=removed.da(20) },
        GitSignsStagedAdd       { bg=added.li(10) },
        GitSignsStagedChange    { bg=changed.li(10) },
        GitSignsStagedDelete    { bg=removed.li(10) },

        -- Shears.nvim
        ShearsAdded    { GitSignsAdd },
        ShearsDeleted  { GitSignsDelete },
        ShearsChanged  { GitSignsChange },

        -- Snacks
        SnacksIndent      { fg=bg_emp },
        SnacksIndentScope { fg=bg_emp.de(50).mix(hsl(0,0,0), 20) },

        -- Render markdown
        RenderMarkdownCode { bg=bg_emp },
    }
end)

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
