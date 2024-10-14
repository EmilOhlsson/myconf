local M = {}

function M.setup(config)
    -- TODO: Set up plugin
    vim.api.nvim_create_user_command('{{cookiecutter.project_slug}}',
        function(opts)
            -- TODO: Do something cool
        end, {
    })
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100:
