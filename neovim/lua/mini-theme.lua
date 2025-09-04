-- Color scheme using mini.colors with OKHSL

-- This is work in progress, and doesn't produce any nice theme at the moment
-- The purpose is to separate the hues from the lightness + saturation, and
-- to assign color properties to certain aspects, like different kind of symbols
-- UI elements, etc. There is still plenty of work to set up a full highlight
-- table below, but it's about a third of the way maybe

local M = {}

local colors = require('mini.colors')

-- Initialize color converter
local convert = colors.convert

-- Some base values
local bg_hex = '#fdf6e3'
local bg_base = convert(bg_hex, 'okhsl')
assert(bg_base ~= nil)

local fg_hex = '#52676f'
local fg_base = convert(fg_hex, 'okhsl')
assert(fg_base ~= nil)

-- Hue palette - defines the color wheel positions
local hs = {
    -- Base hue derived from bg
    base = bg_base.h,

    -- Semantic color hues
    red = 30,
    green = 140,
    blue = 250,
    orange = 60,
    purple = 320,

    -- UI hues
    toolbar = 230,
}

-- Properties palette - defines saturation and lightness for different uses
local ps = {
    -- Backgrounds
    bg = { s = bg_base.s, l = bg_base.l },                     -- Main background
    bg_emphasis = { s = 2, l = bg_base.l - 2 },                -- Slightly emphasized
    bg_cursor = { s = bg_base.s + 10, l = bg_base.l - 2 },     -- Cursor line
    bg_highlight = { s = bg_base.s + 10, l = bg_base.l - 10 }, -- Search highlight
    bg_context = { s = bg_base.s + 5, l = bg_base.l - 3 },     -- Treesitter context
    bg_ui = { s = 30, l = 40 },                                -- UI background -- maybe merge with cursor and context?

    -- Foregrounds
    fg = { s = 30, l = 40 },                               -- Main text
    fg_colorful  = { s = 70, l = 40 },                     -- Colorful text
    fg_muted = { s = 5, l = 50 },                          -- Comments
    fg_subtle = { s = bg_base.s + 5, l = bg_base.l - 20 }, -- NonText, very close to bg
    fg_linenr = { s = 5, l = 70 },                         -- Line numbers
    fg_emphasis = { s = 15, l = 50 },                      -- Brighter fg for statements
    fg_ui = { s = 15, l = 50 },                            -- UI foreground
}


-- Define all highlights in a simplified table format
local highlights = {
    -- Basic highlights
    Normal                      = { fg = { h = hs.base + 180, p = ps.fg }, bg = { h = hs.base, p = ps.bg } },
    String                      = { fg = { h = hs.orange, p = ps.fg_colorful }, gui = 'italic' },
    Number                      = { fg = { h = hs.purple, p = ps.fg_colorful } },
    Title                       = { fg = { h = hs.orange, p = ps.fg_emphasis }, gui = 'bold' },
    Comment                     = { fg = { h = hs.base, p = ps.fg_muted } },
    Todo                        = { fg = { h = hs.orange, p = ps.fg_emphasis }, bg = { h = hs.base, p = ps.bg_emphasis } },

    -- Statements and identifiers
    Statement                   = { fg = { h = hs.base, p = ps.fg_emphasis }, gui = 'bold' },
    Conditional                 = { link = 'Statement' },
    Identifier                  = { fg = { h = hs.orange, p = ps.fg } },
    Type                        = { fg = { h = hs.base, p = ps.fg }, gui = 'bold' },

    -- Line numbers and signs
    LineNr                      = { fg = { h = hs.base, p = ps.fg_subtle } },
    CursorLineNr                = { fg = { h = hs.orange, p = ps.fg_muted }, gui = 'bold' },
    SignColumn                  = { bg = { h = hs.base, p = ps.bg } },
    FoldColumn                  = { fg = { h = hs.base, p = ps.fg_linenr }, bg = { h = hs.base, p = ps.bg } },

    -- Treesitter highlights
    -- ['@class.declaration']      = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@declaration.identifier'] = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@function']               = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@function.call']          = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@method']                 = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@note']                   = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- ['@todo']                   = { link = 'Todo' },
    -- ['@text.todo']              = { link = 'Todo' },

    -- UI elements
    Visual                      = { bg = { h = hs.base, p = ps.bg_ui } },
    CursorLine                  = { bg = { h = hs.base, p = ps.bg_cursor } },
    NonText                     = { fg = { h = hs.base, p = ps.fg_subtle }, gui = 'italic' },
    NvimDapVirtualText          = { link = 'NonText' },

    -- -- DAP debugging
    -- DapBreakpoint               = { fg = { h = hs.red, p = ps.fg_ui } },
    -- DapBreakpointLine           = { bg = { h = hs.red, p = ps.bg_highlight } },
    -- DapBreakpointCurrentLine    = { fg = { h = hs.red, p = ps.fg_ui }, gui = 'bold' },
    -- DapStopped                  = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapStoppedLine              = { bg = { h = hs.green, p = ps.bg_highlight } },
    -- DapStoppedCurrentLine       = { fg = { h = hs.green, p = ps.fg_ui }, gui = 'bold' },
    --
    -- -- DAP UI elements
    -- DapUIBreakpointsCurrentLine = { fg = { h = hs.green, p = ps.fg_ui }, gui = 'bold' },
    -- DapUIBreakpointsInfo        = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapUIBreakpointsPath        = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIDecoration             = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIFloatBorder            = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUILineNumber             = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIModifiedValue          = { fg = { h = hs.blue, p = ps.fg_ui }, gui = 'bold' },
    -- DapUIPlayPause              = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapUIPlayPauseNC            = { fg = { h = hs.green, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIRestart                = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapUIRestartNC              = { fg = { h = hs.green, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIScope                  = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIStepBack               = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIStepBackNC             = { fg = { h = hs.blue, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIStepInto               = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIStepIntoNC             = { fg = { h = hs.blue, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIStepOut                = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIStepOutNC              = { fg = { h = hs.blue, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIStepOver               = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIStepOverNC             = { fg = { h = hs.blue, p = ps.fg_ui }, bg = { h = hs.toolbar, p = ps.bg_ui } },
    -- DapUIStoppedThread          = { fg = { h = hs.blue, p = ps.fg_ui } },
    -- DapUIThread                 = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapUIWatchesValue           = { fg = { h = hs.green, p = ps.fg_ui } },
    -- DapUIWinSelect              = { fg = { h = hs.blue, p = ps.fg_ui }, gui = 'bold' },
    --
    -- -- Popup menu and search
    -- Pmenu                       = { bg = { h = hs.base, p = ps.bg_emphasis } },
    -- Search                      = { bg = { h = hs.base, p = ps.bg_highlight } },
    -- TreesitterContext           = { bg = { h = hs.base, p = ps.bg_context } },
    -- TreesitterContextBottom     = { bg = { h = hs.base, p = ps.bg_context }, gui = 'underline' },

    -- File diffing
    Changed                     = { bg = { h = hs.blue, p = ps.bg_highlight } },
    Added                       = { bg = { h = hs.green, p = ps.bg_highlight } },
    Removed                     = { bg = { h = hs.red, p = ps.bg_highlight } },

    -- -- Litee UI
    -- LTSymbol                    = { fg = { h = hs.orange, p = ps.fg_emphasis }, gui = 'bold' },
    -- LTSymbolDetail              = { fg = { h = hs.blue, p = ps.fg }, gui = 'italic' },
    --
    -- -- LSP references
    -- LspReferenceRead            = { bg = { h = hs.green, p = ps.bg_highlight }, fg = { h = hs.green, p = ps.ref_fg } },
    -- LspReferenceText            = { bg = { h = hs.blue, p = ps.bg_highlight }, fg = { h = hs.blue, p = ps.ref_fg } },
    -- LspReferenceWrite           = { bg = { h = hs.red, p = ps.bg_highlight }, fg = { h = hs.red, p = ps.ref_fg } },
    --
    -- -- Gitsigns
    -- GitSignsAdd                 = { bg = { h = hs.green, p = ps.diff_background_dark } },
    -- GitSignsChange              = { bg = { h = hs.blue, p = ps.diff_background_dark } },
    -- GitSignsDelete              = { bg = { h = hs.red, p = ps.diff_background_dark } },
    -- GitSignsStagedAdd           = { bg = { h = hs.green, p = ps.diff_background_light } },
    -- GitSignsStagedChange        = { bg = { h = hs.blue, p = ps.diff_background_light } },
    -- GitSignsStagedDelete        = { bg = { h = hs.red, p = ps.diff_background_light } },
    --
    -- -- Snacks
    -- SnacksIndent                = { fg = { h = hs.base, p = ps.bg_emphasis } },
    -- SnacksIndentScope           = { fg = { h = hs.base, p = ps.fg_subtle } },
    --
    -- -- Whitespace and special characters
    -- Whitespace                  = { fg = { h = hs.base, p = ps.fg_subtle } },
    -- SpecialKey                  = { fg = { h = hs.base, p = ps.fg_subtle } },
    -- EndOfBuffer                 = { fg = { h = hs.base, p = ps.fg_subtle } },
}

-- Helper to process color specs in the simplified format
local function process_color(spec)
    -- print(' processing color: '..vim.inspect(spec))
    if not spec then return nil end
    if type(spec) == 'string' then return spec end

    return {
        -- Note that `h` can be nil for achromatic colors
        h = ((spec.h or 0) + 360) % 360,
        s = math.min(100, math.max(0, spec.p.s or 0)),
        l = math.min(100, math.max(0, spec.p.l or 0))
    }
end

-- Local to-hex helper
local function to_hex(color)
    if type(color) == 'string' then
        return color
    end
    return colors.convert(color, 'hex')
end

-- Helper function to set highlights
local function hi(name, opts)
    opts = opts or {}

    if opts.link then
        vim.cmd('hi! link ' .. name .. ' ' .. opts.link)
        return
    end

    local cmd = { 'hi', name }

    if opts.fg ~= nil then
        assert(opts.fg.p ~= nil, name .. ' foreground does not have properties')
    end
    if opts.bg ~= nil then
        assert(opts.bg.p ~= nil, name .. ' background does not have properties')
    end


    -- Process color specs
    local fg = process_color(opts.fg)
    local bg = process_color(opts.bg)

    if fg then
        -- print(' - fg='..vim.inspect(fg))
        table.insert(cmd, 'guifg=' .. to_hex(fg))
    end
    if bg then
        -- print(' - bg='..vim.inspect(bg))
        table.insert(cmd, 'guibg=' .. to_hex(bg))
    end
    if opts.gui then
        table.insert(cmd, 'gui=' .. opts.gui)
    end

    vim.cmd(table.concat(cmd, ' '))
end

function M.setup()
    -- Clear existing highlights
    vim.cmd('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    vim.o.termguicolors = true
    vim.g.colors_name = 'minicolors_theme'

    -- Apply all highlights from the table
    for name, opts in pairs(highlights) do
        -- print('name='..name..', opts='..vim.inspect(opts))
        hi(name, opts)
    end
end

-- Export palettes for debugging or external use
function M.get_palettes()
    return {
        hues = hs,
        properties = ps
    }
end

-- Export highlights table for debugging or customization
function M.get_highlights()
    return highlights
end

-- For use as a colorscheme
M.load = M.setup

return M
