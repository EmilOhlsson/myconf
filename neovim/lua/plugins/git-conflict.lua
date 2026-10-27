--- git-conflict: view and resolve git merge conflicts.
---
--- `view()` shows the conflict under the cursor in four floating windows laid out as a grid. The top
--- row compares base with ours, the bottom row compares base with theirs.
--- `pick()` keeps the section the cursor is in and removes the rest of the conflict.
---
--- The base is taken from the `|||||||` section (merge.conflictStyle = diff3/zdiff3) when present,
--- otherwise it is looked up in the git index (stage 1) using the surrounding lines as anchors.
---
--- Usage:
---   require('plugins.git-conflict').setup({ size = 0.8 })
---   :ConflictView, :ConflictPick

local M = {}

--- @class GitConflictOptions
--- @field size? number Fraction of the editor taken up by the grid (0-1)
--- @field border? string Border style for the floating windows

local DEFAULT_CONFIG = {
    size = 0.8,
    border = 'rounded',
}

local config = DEFAULT_CONFIG

local ns = vim.api.nvim_create_namespace('git-conflict')

--- Number of lines around a conflict used to anchor it in the git base version
local CONTEXT = 3

--- @class GitConflict
--- @field start integer Line of the `<<<<<<<` marker (1-based)
--- @field base_mark? integer Line of the `|||||||` marker
--- @field sep integer Line of the `=======` marker
--- @field end_ integer Line of the `>>>>>>>` marker
--- @field ours string[]
--- @field base? string[]
--- @field theirs string[]

local function notify(msg, level)
    vim.notify('git-conflict: ' .. msg, level or vim.log.levels.WARN)
end

local MARKERS = { ['<<<<<<<'] = 'start', ['|||||||'] = 'base', ['>>>>>>>'] = 'end' }

--- @param line string
--- @return 'start'|'base'|'sep'|'end'|nil
local function marker_at(line)
    if line == '=======' then
        return 'sep'
    end
    return MARKERS[line:sub(1, 7)]
end

--- Find the conflict enclosing the given line
--- @param lines string[] All lines of the buffer
--- @param row integer 1-based line number
--- @return GitConflict?
local function find_conflict(lines, row)
    local start
    for i = row, 1, -1 do
        local m = marker_at(lines[i])
        if m == 'start' then
            start = i
            break
        elseif m == 'end' and i < row then
            return nil
        end
    end
    if not start then
        return nil
    end

    local base_mark, sep
    for i = start + 1, #lines do
        local m = marker_at(lines[i])
        if m == 'start' then
            return nil
        elseif m == 'base' and not (base_mark or sep) then
            base_mark = i
        elseif m == 'sep' and not sep then
            sep = i
        elseif m == 'end' then
            if not sep or row > i then
                return nil
            end
            return {
                start = start,
                base_mark = base_mark,
                sep = sep,
                end_ = i,
                ours = vim.list_slice(lines, start + 1, (base_mark or sep) - 1),
                base = base_mark and vim.list_slice(lines, base_mark + 1, sep - 1),
                theirs = vim.list_slice(lines, sep + 1, i - 1),
            }
        end
    end
    return nil
end

--- Which section of the conflict a line belongs to. Marker lines belong to the section they start
--- (the closing marker belongs to theirs).
--- @param conflict GitConflict
--- @param row integer
--- @return 'ours'|'base'|'theirs'
local function section_at(conflict, row)
    if row >= conflict.sep then
        return 'theirs'
    elseif conflict.base_mark and row >= conflict.base_mark then
        return 'base'
    end
    return 'ours'
end

--- Lines around the conflict, stopping at other conflict markers
--- @param lines string[]
--- @param conflict GitConflict
--- @return string[] before, string[] after
local function context_lines(lines, conflict)
    local before = {}
    for i = conflict.start - 1, math.max(1, conflict.start - CONTEXT), -1 do
        if marker_at(lines[i]) then
            break
        end
        table.insert(before, 1, lines[i])
    end
    local after = {}
    for i = conflict.end_ + 1, math.min(#lines, conflict.end_ + CONTEXT) do
        if marker_at(lines[i]) then
            break
        end
        after[#after + 1] = lines[i]
    end
    return before, after
end

--- @param haystack string[]
--- @param needle string[]
--- @param init integer
--- @return integer? index of the first line of the match
local function find_block(haystack, needle, init)
    for i = init, #haystack - #needle + 1 do
        local j = 1
        while j <= #needle and haystack[i + j - 1] == needle[j] do
            j = j + 1
        end
        if j > #needle then
            return i
        end
    end
    return nil
end

--- Look the base up in git index stage 1
--- @param file string Absolute path of the conflicted file
--- @param lines string[] All lines of the buffer
--- @param conflict GitConflict
--- @return string[]?
local function base_from_git(file, lines, conflict)
    if file == '' then
        return nil
    end
    local show = vim.system({ 'git', 'show', ':1:./' .. vim.fs.basename(file) }, {
        cwd = vim.fs.dirname(file),
        text = true,
    }):wait()
    if show.code ~= 0 then
        return nil
    end
    local base_lines = vim.split(show.stdout, '\n', { plain = true })
    if base_lines[#base_lines] == '' then
        table.remove(base_lines)
    end

    local before, after = context_lines(lines, conflict)
    local first = find_block(base_lines, before, 1)
    if not first then
        return nil
    end
    local from = first + #before
    local last = find_block(base_lines, after, from)
    if not last then
        return nil
    end
    return vim.list_slice(base_lines, from, last - 1)
end

--- Replace the conflict with the section under the cursor
function M.pick()
    local buf = vim.api.nvim_get_current_buf()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local conflict = find_conflict(vim.api.nvim_buf_get_lines(buf, 0, -1, false), row)
    if not conflict then
        notify('cursor is not inside a conflict')
        return
    end

    vim.api.nvim_buf_set_lines(buf, conflict.start - 1, conflict.end_, false,
        conflict[section_at(conflict, row)])
    vim.api.nvim_win_set_cursor(0, { math.min(conflict.start, vim.api.nvim_buf_line_count(buf)), 0 })
end

--- Highlight differing lines between two buffers
--- @param base_buf integer
--- @param other_buf integer
--- @param base_lines string[]
--- @param other_lines string[]
local function mark_diff(base_buf, other_buf, base_lines, other_lines)
    local hunks = vim.diff(
        table.concat(base_lines, '\n') .. '\n',
        table.concat(other_lines, '\n') .. '\n',
        { result_type = 'indices' }
    )
    --- @cast hunks integer[][]
    local function mark(buf, first, count, hl)
        for l = first, first + count - 1 do
            vim.api.nvim_buf_set_extmark(buf, ns, l - 1, 0, { line_hl_group = hl })
        end
    end
    for _, h in ipairs(hunks) do
        local a_start, a_count, b_start, b_count = h[1], h[2], h[3], h[4]
        mark(base_buf, a_start, a_count, b_count == 0 and 'DiffDelete' or 'DiffChange')
        mark(other_buf, b_start, b_count, a_count == 0 and 'DiffAdd' or 'DiffChange')
    end
end

--- Windows of the currently open view, empty when there is none
--- @type integer[]
local view_wins = {}

--- @param step integer
local function cycle(step)
    local i = vim.fn.index(view_wins, vim.api.nvim_get_current_win())
    if i < 0 then
        return
    end
    local next_win = view_wins[(i + step) % #view_wins + 1]
    if vim.api.nvim_win_is_valid(next_win) then
        vim.api.nvim_set_current_win(next_win)
    end
end

--- Move to the next pane of the conflict view (no-op outside of it)
function M.next_pane()
    cycle(1)
end

--- Move to the previous pane of the conflict view (no-op outside of it)
function M.prev_pane()
    cycle(-1)
end

--- Show the conflict under the cursor as base/ours over base/theirs
function M.view()
    local src = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(src, 0, -1, false)
    local conflict = find_conflict(lines, vim.api.nvim_win_get_cursor(0)[1])
    if not conflict then
        notify('cursor is not inside a conflict')
        return
    end

    local base = conflict.base or base_from_git(vim.api.nvim_buf_get_name(src), lines, conflict)
    if not base then
        notify('no base available (use merge.conflictStyle=diff3); showing empty base')
        base = {}
    end

    local panes = {
        { title = 'Base', lines = base },
        { title = 'Ours', lines = conflict.ours },
        { title = 'Base', lines = base },
        { title = 'Theirs', lines = conflict.theirs },
    }

    local ft = vim.bo[src].filetype
    local editor_h = vim.o.lines - vim.o.cmdheight - 1
    local total_w = math.floor(vim.o.columns * config.size)
    local total_h = math.floor(editor_h * config.size)
    local cell_w = math.floor(total_w / 2)
    local cell_h = math.floor(total_h / 2)
    local origin_col = math.floor((vim.o.columns - total_w) / 2)
    local origin_row = math.floor((editor_h - total_h) / 2)

    local wins, bufs = {}, {}
    for i, pane in ipairs(panes) do
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = 'wipe'
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, pane.lines)
        vim.bo[buf].filetype = ft
        vim.bo[buf].modifiable = false

        local win = vim.api.nvim_open_win(buf, i == 1, {
            relative = 'editor',
            row = origin_row + math.floor((i - 1) / 2) * cell_h,
            col = origin_col + (i - 1) % 2 * cell_w,
            width = cell_w - 2,
            height = cell_h - 2,
            style = 'minimal',
            border = config.border,
            title = ' ' .. pane.title .. ' ',
            title_pos = 'center',
        })
        vim.wo[win].wrap = false
        bufs[i], wins[i] = buf, win
    end

    mark_diff(bufs[1], bufs[2], base, conflict.ours)
    mark_diff(bufs[3], bufs[4], base, conflict.theirs)

    view_wins = wins

    local group = vim.api.nvim_create_augroup('git-conflict-view', { clear = true })
    local function close()
        if view_wins == wins then
            view_wins = {}
        end
        pcall(vim.api.nvim_del_augroup_by_id, group)
        for _, win in ipairs(wins) do
            pcall(vim.api.nvim_win_close, win, true)
        end
    end

    for _, buf in ipairs(bufs) do
        vim.keymap.set('n', 'q', close, { buffer = buf, nowait = true, desc = 'Close conflict view' })
        vim.keymap.set('n', '<Esc>', close, { buffer = buf, nowait = true, desc = 'Close conflict view' })
    end

    vim.api.nvim_create_autocmd('WinClosed', {
        group = group,
        pattern = vim.tbl_map(tostring, wins),
        callback = vim.schedule_wrap(close),
    })
end

--- @param opts? GitConflictOptions Optional configuration table
function M.setup(opts)
    config = vim.tbl_extend('force', DEFAULT_CONFIG, opts or {})

    vim.api.nvim_create_user_command('ConflictView', M.view, {
        desc = 'Show the conflict under the cursor as base/ours and base/theirs',
    })
    vim.api.nvim_create_user_command('ConflictPick', M.pick, {
        desc = 'Keep the conflict section under the cursor and remove the rest',
    })
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
