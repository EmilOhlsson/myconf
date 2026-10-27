local map = require('core.util').map

return {
    {
        module = 'gitsigns',
        setup = function(gitsigns)
            gitsigns.setup {
                attach_to_untracked = true,
                current_line_blame = true,
                word_diff = true,
                preview_config = {
                    border = 'rounded',
                    style = 'minimal',
                },
                on_attach = function(bufnr)
                    local function buf_map(mode, key, cmd, description)
                        map(mode, key, cmd, description, { buffer = bufnr })
                    end
                    buf_map('n', '[h',  gitsigns.prev_hunk, 'Jump to previous changed hunk')
                    buf_map('n', ']h', gitsigns.next_hunk, 'Jump to next changed hunk')

                    buf_map('n', ';hd', gitsigns.diffthis, 'Show diff for current buffer')
                    buf_map('n', ';hp', gitsigns.preview_hunk, 'Preview patch from current hunk')
                    buf_map('n', ';hR', gitsigns.reset_buffer, 'Reset current buffer')
                    buf_map('n', ';hr', gitsigns.reset_hunk, 'Reset current hunk')
                    buf_map('n', ';hS', gitsigns.stage_buffer, 'Stage current buffer')
                    buf_map('n', ';hs', gitsigns.stage_hunk, 'Stage current hunk')
                end,
            }

            vim.api.nvim_create_user_command('DiffMergeBase', function(args)
                local branch = args.args ~= '' and args.args or 'main'
                -- Run git where the file is, so this works for files outside the current repo
                local dir = vim.fn.expand('%:p:h')
                local cmd = { 'git', 'merge-base', 'HEAD', branch }
                local result = vim.system(cmd, { cwd = dir, text = true }):wait()
                if result.code ~= 0 then
                    vim.notify('DiffMergeBase: ' .. vim.trim(result.stderr), vim.log.levels.ERROR)
                    return
                end
                gitsigns.diffthis(vim.trim(result.stdout))
            end, {
                nargs = '?',
                desc = 'Diff current file against the merge-base with a branch (default: main)',
            })
        end,
    },
    {
        -- Git pickers. Snacks itself is set up in ui.lua
        module = 'snacks',
        setup = function(snacks)
            map('n', '<space>gd', function()
                snacks.picker.git_diff({ staged = false, group = true })
            end, 'Pick unstaged changes, by file')
            map('n', '<space>gD', function()
                snacks.picker.git_diff({ staged = true, group = true })
            end, 'Pick staged changes, by file')
            map('n', '<space>gs', snacks.picker.git_status, 'Pick: git status')
        end,
    },
    {
        setup = function()
            local git_conflict = require('plugins.git-conflict')
            git_conflict.setup()
            map('n', ';rp', git_conflict.pick, 'Resolve conflict: pick section under cursor')
            map('n', ';rr', git_conflict.view, 'Resolve conflict: view base/ours/theirs')
            map('n', ']r', git_conflict.next_pane, 'Resolve conflict: next view pane')
            map('n', '[r', git_conflict.prev_pane, 'Resolve conflict: previous view pane')
        end,
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
