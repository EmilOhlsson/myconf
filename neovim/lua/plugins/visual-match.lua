--- visual-match: highlight all occurrences of the current visual selection.
---
--- Matches are highlighted with the `VisualMatch` highlight group while in charwise visual mode.
--- Only single-line selections are considered, and matching is literal and case-sensitive.
---
--- Usage:
---   require('plugins.visual-match').setup({ max_length = 200 })

local M = {}

--- @class VisualMatchOptions
--- @field max_length? integer Selections longer than this are ignored

local DEFAULT_CONFIG = {
    max_length = 200,
}

local config = DEFAULT_CONFIG

local ns = vim.api.nvim_create_namespace('visual-match')

--- Buffer currently holding highlights. At most one buffer has highlights at any time.
--- @type integer?
local highlighted_buf

local function clear()
    if highlighted_buf and vim.api.nvim_buf_is_valid(highlighted_buf) then
        vim.api.nvim_buf_clear_namespace(highlighted_buf, ns, 0, -1)
    end
    highlighted_buf = nil
end

--- Re-highlight matches of the selection in the visible part of the current window
local function update()
    clear()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return
    end

    local sel_start = vim.fn.getpos('v')
    local sel_end = vim.fn.getpos('.')
    if sel_start[2] ~= sel_end[2] then
        return
    end
    local text = vim.fn.getregion(sel_start, sel_end, { type = 'v' })[1]
    if text == '' or #text > config.max_length then
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local sel_row = sel_end[2] - 1
    local sel_col = math.min(sel_start[3], sel_end[3]) - 1
    local first = vim.fn.line('w0') - 1
    local lines = vim.api.nvim_buf_get_lines(buf, first, vim.fn.line('w$'), false)

    for i, line in ipairs(lines) do
        local row = first + i - 1
        local s, e = line:find(text, 1, true)
        while s do
            if row ~= sel_row or s - 1 ~= sel_col then
                vim.api.nvim_buf_set_extmark(buf, ns, row, s - 1, {
                    end_col = e,
                    hl_group = 'VisualMatch',
                    priority = 100,
                })
            end
            s, e = line:find(text, e + 1, true)
        end
    end
    highlighted_buf = buf
end

local function set_default_highlight()
    vim.api.nvim_set_hl(0, 'VisualMatch', { link = 'Visual', default = true })
end

--- @param opts? VisualMatchOptions Optional configuration table
function M.setup(opts)
    config = vim.tbl_extend('force', DEFAULT_CONFIG, opts or {})

    set_default_highlight()

    local group = vim.api.nvim_create_augroup('visual-match', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = set_default_highlight,
    })
    -- update() clears first, so leaving visual mode is handled by the same callback
    vim.api.nvim_create_autocmd({ 'ModeChanged', 'CursorMoved', 'WinScrolled' }, {
        group = group,
        callback = update,
    })
    vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
        group = group,
        callback = clear,
    })
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
