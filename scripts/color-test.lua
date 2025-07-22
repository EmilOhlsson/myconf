#!/usr/bin/env luajit

local myconf_scripts = os.getenv('HOME') .. '/myconf/lua/?.lua'
package.path = package.path .. ';' .. myconf_scripts

local theme = require('theme')

print('Backgrount color: ' .. theme.background)
print('Foreground color: ' .. theme.foreground)

for i, v in ipairs(theme.ansi) do
    print("ansi: " .. i .. ": " .. v.h .. ", " .. v.s .. ", " .. v.l)
end

for i, v in ipairs(theme.brights) do
    print("brigthts: " .. i .. ": " .. v.h .. ", " .. v.s .. ", " .. v.l)
end

-- Function to print a color table for a specific text style
local function print_color_table(style_name, style_code)
    print("\n" .. string.rep("=", 50))
    print(string.upper(style_name) .. " COLOR TABLE")
    print(string.rep("=", 50))

    -- Header row with foreground color labels
    io.write("BG\\FG\t")
    io.write("DEF\t")
    for fg = 0, 7 do
        io.write(fg .. "\t")
    end
    io.write("\n")

    -- Default background row
    io.write("DEF\t")
    io.write(style_code .. "abc123\x1b[0m\t")
    for fg = 0, 7 do
        io.write(style_code .. "\x1b[3" .. fg .. "mabc123\x1b[0m\t")
    end
    io.write("\n")

    -- Background color rows
    for bg = 0, 7 do
        io.write(bg .. "\t")
        io.write(style_code .. "\x1b[4" .. bg .. "mabc123\x1b[0m\t")
        for fg = 0, 7 do
            io.write(style_code .. "\x1b[4" .. bg .. ";3" .. fg .. "mabc123\x1b[0m\t")
        end
        io.write("\n")
    end
    io.flush()
end

-- Print tables for different text styles
print_color_table("normal", "")
print_color_table("bold", "\x1b[1m")
print_color_table("dim", "\x1b[2m")
print_color_table("italic", "\x1b[3m")
print_color_table("underline", "\x1b[4m")
print_color_table("blink", "\x1b[5m")
print_color_table("reverse", "\x1b[7m")
print_color_table("strikethrough", "\x1b[9m")
