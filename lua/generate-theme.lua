local theme = require('theme')

local function hex(color)
    return tostring(color):sub(2) -- strip leading #
end

for i = 1, 8 do
    print(string.format("palette = %d=%s", i - 1, hex(theme.ansi[i])))
end
for i = 1, 8 do
    print(string.format("palette = %d=%s", i + 7, hex(theme.brights[i])))
end

print("background = " .. hex(theme.background))
print("foreground = " .. hex(theme.foreground))
print("cursor-color = " .. hex(theme.cursor_bg))
print("cursor-text = " .. hex(theme.cursor_fg))
print("selection-background = " .. hex(theme.selection_bg))
print("selection-foreground = " .. hex(theme.selection_fg))
