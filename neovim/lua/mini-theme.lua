-- Color scheme using mini.colors with OKHSL

-- OKHSL colors are described as
-- Hue: 0-360, Saturation: 0-100, Lightness: 0-100

-- This is work in progress, and doesn't produce any nice theme at the moment
-- The purpose is to separate the hues from the lightness + saturation, and
-- to assign color properties to certain aspects, like different kind of symbols
-- UI elements, etc. There is still plenty of work to set up a full highlight
-- table below, but it's about a third of the way maybe

local M = {}

-- TODO: This is the only function needed from `mini.colors`. We could very easily just replace it 
-- with a local implementation.
local convert = require('mini.colors').convert

-- Some base values
local bg_hex = '#fdf6e3'
-- {
--   h = 90,
--   l = 96.91632557906,
--   s = 73.71562509253
-- }

local bg_base = convert(bg_hex, 'okhsl')
assert(bg_base ~= nil)

local fg_hex = '#52676f'
local fg_base = convert(fg_hex, 'okhsl')
assert(fg_base ~= nil)

-- Hue palette - defines the color wheel positions
local hues = {
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
local props = {
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
    Normal  = { fg = { h = hues.base + 180, p = props.fg },             bg = { h = hues.base, p = props.bg, } },
    String  = { fg = { h = hues.orange,     s = 90, l = 40 },           gui = 'italic' },
    Number  = { fg = { h = hues.purple,     s = 90, l = 40 }, },
    Title   = { fg = { h = hues.orange,     s = 90, l = 40 },           gui = 'bold' },
    Comment = { fg = { h = hues.base,       s = 90, l = 50 } },
    Todo    = { fg = { h = hues.orange,     s = 90, l = 30 },    bg = { h = hues.base, p = props.bg_emphasis, } },

    -- Statements and identifiers
    Statement                   = { fg = { h = hues.base, p = props.fg_emphasis }, gui = 'bold' },
    Conditional                 = { link = 'Statement' },
    Identifier                  = { fg = { h = hues.orange, p = props.fg } },
    Type                        = { fg = { h = hues.base, p = props.fg }, gui = 'bold' },

    -- Line numbers and signs
    LineNr                      = { fg = { h = hues.base,   p = props.fg_subtle } },
    CursorLineNr                = { fg = { h = hues.orange, p = props.fg_muted }, gui = 'bold' },
    SignColumn                  = { bg = { h = hues.base,   p = props.bg } },
    FoldColumn                  = { fg = { h = hues.base,   p = props.fg_linenr }, bg = { h = hues.base, p = props.bg } },

    -- Treesitter highlights
    -- ['@class.declaration']      = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@declaration.identifier'] = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@function']               = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@function.call']          = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@method']                 = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@note']                   = { bg = { h = hues.base, p = props.bg_emphasis } },
    -- ['@todo']                   = { link = 'Todo' },
    -- ['@text.todo']              = { link = 'Todo' },

    -- UI elements
    Visual                      = { bg = { h = hues.base, s = bg_base.s + 10, l = bg_base.l - 10 } },
    CursorLine                  = { bg = { h = hues.base, p = props.bg_cursor } },
    NonText                     = { fg = { h = hues.base, p = props.fg_subtle }, gui = 'italic' },
    NvimDapVirtualText          = { link = 'NonText' },

    -- -- DAP debugging
    -- DapBreakpoint               = { fg = { h = hues.red, p = props.fg_ui } },
    -- DapBreakpointLine           = { bg = { h = hues.red, p = props.bg_highlight } },
    -- DapBreakpointCurrentLine    = { fg = { h = hues.red, p = props.fg_ui }, gui = 'bold' },
    -- DapStopped                  = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapStoppedLine              = { bg = { h = hues.green, p = props.bg_highlight } },
    -- DapStoppedCurrentLine       = { fg = { h = hues.green, p = props.fg_ui }, gui = 'bold' },
    --
    -- -- DAP UI elements
    -- DapUIBreakpointsCurrentLine = { fg = { h = hues.green, p = props.fg_ui }, gui = 'bold' },
    -- DapUIBreakpointsInfo        = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapUIBreakpointsPath        = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIDecoration             = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIFloatBorder            = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUILineNumber             = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIModifiedValue          = { fg = { h = hues.blue, p = props.fg_ui }, gui = 'bold' },
    -- DapUIPlayPause              = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapUIPlayPauseNC            = { fg = { h = hues.green, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIRestart                = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapUIRestartNC              = { fg = { h = hues.green, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIScope                  = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIStepBack               = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIStepBackNC             = { fg = { h = hues.blue, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIStepInto               = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIStepIntoNC             = { fg = { h = hues.blue, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIStepOut                = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIStepOutNC              = { fg = { h = hues.blue, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIStepOver               = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIStepOverNC             = { fg = { h = hues.blue, p = props.fg_ui }, bg = { h = hues.toolbar, p = props.bg_ui } },
    -- DapUIStoppedThread          = { fg = { h = hues.blue, p = props.fg_ui } },
    -- DapUIThread                 = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapUIWatchesValue           = { fg = { h = hues.green, p = props.fg_ui } },
    -- DapUIWinSelect              = { fg = { h = hues.blue, p = props.fg_ui }, gui = 'bold' },
    --
    -- -- Popup menu and search
    Pmenu                       = { bg = { h = hues.base, s = bg_base.s + 10, l = bg_base.l - 10 } },
    Search                      = { bg = { h = hues.base, s = bg_base.s + 10, l = bg_base.l - 10 } },
    TreesitterContext           = { bg = { h = hues.base, s = bg_base.s + 10, l = bg_base.l - 5 } },
    TreesitterContextBottom     = { bg = { h = hues.base, s = bg_base.s + 10, l = bg_base.l - 5 }, gui = 'underline' },

    -- File diffing
    Changed                     = { bg = { h = hues.blue, s = 90, l = 85, } },
    Added                       = { bg = { h = hues.green, s = 90, l = 85, } },
    Removed                     = { bg = { h = hues.red, s = 90, l = 85, } },

    -- -- Litee UI
    -- LTSymbol                    = { fg = { h = hues.orange, p = props.fg_emphasis }, gui = 'bold' },
    -- LTSymbolDetail              = { fg = { h = hues.blue, p = props.fg }, gui = 'italic' },
    --
    -- -- LSP references
    LspReferenceRead            = { bg = { h = hues.green, s = 90, l = 95 }, },
    LspReferenceText            = { bg = { h = hues.blue, s = 90, l = 95 }, },
    LspReferenceWrite           = { bg = { h = hues.red, s = 90, l = 95 }, },
    --
    -- Gitsigns
    GitSignsAdd                 = { bg = { h = hues.green, s = 90, l = 85, } },
    GitSignsAddInline           = { bg = { h = hues.green, s = 90, l = 95, } },
    GitSignsChange              = { bg = { h = hues.blue,  s = 90, l = 85, } },
    GitSignsChangeInline        = { bg = { h = hues.blue,  s = 90, l = 95, } },
    GitSignsDelete              = { bg = { h = hues.red,   s = 90, l = 85, } },
    GitSignsDeleteInline        = { bg = { h = hues.red,   s = 90, l = 95, } },
    GitSignsStagedAdd           = { bg = { h = hues.green, s = 90, l = 95, } },
    GitSignsStagedAddInline     = { bg = { h = hues.green, s = 90, l = 95, } },
    GitSignsStagedChange        = { bg = { h = hues.blue,  s = 90, l = 95, } },
    GitSignsStagedChangeInline  = { bg = { h = hues.blue,  s = 90, l = 95, } },
    GitSignsStagedDelete        = { bg = { h = hues.red,   s = 90, l = 95, } },
    GitSignsStagedDeleteInline  = { bg = { h = hues.red,   s = 90, l = 95, } },
    --
    -- -- Snacks
    -- SnacksIndent                = { fg = { h = hues.base, p = props.bg_emphasis } },
    -- SnacksIndentScope           = { fg = { h = hues.base, p = props.fg_subtle } },
    --
    -- -- Whitespace and special characters
    -- Whitespace                  = { fg = { h = hues.base, p = props.fg_subtle } },
    -- SpecialKey                  = { fg = { h = hues.base, p = props.fg_subtle } },
    -- EndOfBuffer                 = { fg = { h = hues.base, p = props.fg_subtle } },
}

--- Resolve color
local function resolve_color(spec)
    -- print(' processing color: '..vim.inspect(spec))
    if not spec then return nil end
    if type(spec) == 'string' then return spec end

    return {
        -- Note that `h` can be nil for achromatic colors
        h = ((spec.h or spec.p.h or 0) + 360) % 360,              -- Keep within 0-360
        s = math.min(100, math.max(0, spec.s or spec.p.s or 0)),  -- Clamp to 0-100
        l = math.min(100, math.max(0, spec.l or spec.p.l or 0)),  -- Clamp to 0-100
    }
end

-- Local to-hex helper
local function to_hex(color)
    if type(color) == 'string' then
        return color
    end
    return convert(color, 'hex')
end

-- Helper function to set highlights
local function hi(name, opts)
    opts = opts or {}

    if opts.link then
        vim.cmd('hi! link ' .. name .. ' ' .. opts.link)
        return
    end

    local cmd = { 'hi', name }

    local fg = resolve_color(opts.fg)
    local bg = resolve_color(opts.bg)

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

-- For use as a colorscheme
M.load = M.setup

return M
