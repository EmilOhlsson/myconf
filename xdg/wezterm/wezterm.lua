local myconf_scripts = os.getenv('HOME') .. '/myconf/lua/?.lua'
package.path = package.path .. ';' .. myconf_scripts

local wezterm = require('wezterm')
local theme = require('theme')
local func = require('func')

local act = wezterm.action

-- Default keys: https://wezterm.org/config/default-keys.html
local config = {
    default_cursor_style = 'BlinkingBar',
    use_fancy_tab_bar = false,
    colors = {
        background = tostring(theme.background),
        foreground = tostring(theme.foreground),
        cursor_bg = tostring(theme.cursor_bg),
        cursor_fg = tostring(theme.cursor_fg),
        selection_bg = tostring(theme.selection_bg),
        selection_fg = tostring(theme.selection_fg),
        ansi = func.map_tbl(tostring, theme.ansi),
        brights = func.map_tbl(tostring, theme.brights),
    },
    font = wezterm.font('Cascadia Code NF'),
    font_size = 10.0,
    keys = {
        { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
        { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
    }
}

-- ctrl+shift+z -- zoom state
-- ctrl+shift+t -- new tab
-- ctrl+shift+n -- new window
-- ctrl+shift+c,v -- copy/paste
-- ctrl+pageup,pagedown -- Prev/next tab
-- ctrl+shift+r -- reload config
-- ctrl+shift+alt+",% -- split vertical horizontal
-- ctrl+shift+arrow -- move to split
-- ctrl+shift+alt+arrow -- Resize split

return config

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
