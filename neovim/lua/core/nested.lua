--- Nested Neovim: a `nvim` started in a :terminal of this Neovim ($NVIM is set) opens its files in a
--- floating window of the parent instead, and waits until that window is closed. That way tools like
--- `git commit` block until the file is done.

local M = {}

-- Set by the parent when its floating window is closed
M.done = false

--- Child side: hand the files to the parent and wait. Returns if Neovim should start up normally
M.forward = function()
    if vim.env.NVIM == nil then
        return
    end

    -- Options can't be forwarded, so only `nvim [files]` is handled. Neovim adds --embed itself,
    -- since the TUI runs as a separate process
    local files = {}
    for i = 2, #vim.v.argv do
        local arg = vim.v.argv[i]
        if arg ~= '--embed' then
            if vim.startswith(arg, '-') or vim.startswith(arg, '+') then
                return
            end
            files[#files + 1] = vim.fn.fnamemodify(arg, ':p')
        end
    end

    local chan = vim.fn.sockconnect('pipe', vim.env.NVIM, { rpc = true })
    -- The parent might be a Neovim running without this config
    local check = "return package.loaded['core.nested'] ~= nil"
    if not vim.rpcrequest(chan, 'nvim_exec_lua', check, {}) then
        vim.fn.chanclose(chan)
        return
    end

    -- The channel id as the parent sees it, so it can notify us
    local id = vim.rpcrequest(chan, 'nvim_get_api_info')[1]
    vim.rpcrequest(chan, 'nvim_exec_lua', "require('core.nested').open(...)", { files, id })

    -- Stop waiting if the parent goes away
    while not M.done do
        vim.wait(1000, function() return M.done end)
        if not M.done and not pcall(vim.rpcrequest, chan, 'nvim_get_api_info') then
            break
        end
    end
    vim.cmd('qall!')
end

--- Parent side: open `files` in a floating window, and notify the child on `chan` when it's closed
M.open = function(files, chan)
    vim.api.nvim_set_hl(0, 'NestedFloat', { link = 'NormalFloat', default = true })

    local existing = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        existing[buf] = true
    end
    local bufs = {}
    for _, file in ipairs(files) do
        local buf = vim.fn.bufadd(file)
        vim.bo[buf].buflisted = true
        bufs[#bufs + 1] = buf
    end
    if #bufs == 0 then
        bufs[1] = vim.api.nvim_create_buf(true, false)
    end

    local prev_win = vim.api.nvim_get_current_win()
    local width = math.min(100, vim.o.columns - 4)
    local height = math.floor(vim.o.lines * 0.8)
    local win = vim.api.nvim_open_win(bufs[1], true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        zindex = 60,                                            -- Above FloatTerm, which uses 50
    })
    vim.wo[win].winhighlight = 'NormalFloat:NestedFloat'
    vim.cmd.stopinsert()

    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(win),
        once = true,
        callback = function()
            vim.rpcnotify(chan, 'nvim_exec_lua', "require('core.nested').done = true", {})
            vim.schedule(function()
                -- Wipe the buffers, so a file that is rewritten for every use (COMMIT_EDITMSG) is
                -- read fresh next time. Keep unsaved changes and buffers shown elsewhere
                for _, buf in ipairs(bufs) do
                    local keep = existing[buf] or not vim.api.nvim_buf_is_valid(buf)
                        or vim.bo[buf].modified or vim.fn.bufwinid(buf) ~= -1
                    if not keep then
                        vim.api.nvim_buf_delete(buf, {})
                    end
                end
                if vim.api.nvim_win_is_valid(prev_win) then
                    vim.api.nvim_set_current_win(prev_win)
                    if vim.bo[vim.api.nvim_win_get_buf(prev_win)].buftype == 'terminal' then
                        vim.cmd.startinsert()
                    end
                end
            end)
        end,
    })
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
