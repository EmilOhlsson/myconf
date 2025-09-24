-- This is where neovim currently stores plugins
local lush_path = os.getenv('HOME') .. '/.local/share/nvim/plugged/lush.nvim/lua/?.lua'
package.path = package.path .. ';' .. lush_path

local lush = require('lush')
local hsl = lush.hsl

-- Table of base values
local black = hsl(0, 0, 0)
local red = hsl(0, 100, 50)
local yellow = hsl(40, 100, 50)
local green = hsl(80, 100, 50)
local cyan = hsl(180, 100, 50)
local blue = hsl(240, 100, 50)
local magenta = hsl(300, 100, 50)
local white = hsl(0, 0, 100)

local M = {
    background   = hsl("#fdf6e3"),
    foreground   = hsl("#52676f"),
    cursor_bg    = hsl("#52676f"),
    cursor_fg    = hsl("#fdf6e3"),
    selection_bg = hsl("#e9e2cb"),
    selection_fg = hsl("#fcf4dc"),

    ansi         = {
        hsl("#e4e4e4"), -- "Black"
        hsl("#d70000"), -- "Red"
        hsl("#5f8700"), -- "Green"
        hsl("#af8700"), -- "Yellow"
        hsl("#0087ff"), -- "Blue"
        hsl("#af005f"), -- "Magenta"
        hsl("#00afaf"), -- "Cyan"
        hsl("#262626"), -- "White"
    },
    brights      = {
        hsl("#ffffd7"),
        hsl("#d75f00"),
        hsl("#585858"),
        hsl("#626262"),
        hsl("#808080"),
        hsl("#5f5faf"),
        hsl("#8a8a8a"),
        hsl("#1c1c1c"),
    },
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
