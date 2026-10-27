vim.api.nvim_create_autocmd({'TextYankPost'}, {
    callback = function(_)
        vim.highlight.on_yank({
            on_visual = false
        })
    end
})

-- Read skeleton files when available
local skel_group = vim.api.nvim_create_augroup('skeletons', {clear=true})
vim.api.nvim_create_autocmd({'BufNewFile'}, {
    group = skel_group,
    pattern = { '*.*' },
    callback = function(env)
        local ext = vim.fn.expand('%:e')
        if vim.fn.line('$') > 1 or vim.fn.getline(1) ~= '' or ext == '' then
            return
        end

        -- Construct template path
        local templates = require('core.bootstrap').paths.templates
        local template_path = templates .. '/skeleton.' .. ext
        if vim.fn.filereadable(template_path) == 0 then
            return
        end

        -- Read template content
        local template_lines = vim.fn.readfile(template_path)

        -- Insert template content into buffer
        vim.api.nvim_buf_set_lines(env.buf, 0, -1, false, template_lines)

        -- Move cursor to first line
        local win = vim.fn.bufwinid(env.buf)
        if win ~= -1 then
            vim.api.nvim_win_set_cursor(win, { 1, 0 })
        end
    end,
})

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
