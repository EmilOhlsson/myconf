local M = {}

local debug = function() end

function M.setup(config)
    -- TODO: Set up plugin
    if config.debug then
        debug = function(msg) print(msg) end
    end

    debug('Setting up plugin command(s)')
    vim.api.nvim_create_user_command('{{cookiecutter.project_slug}}',
        function()
            -- TODO: Do something cool
        end, {})
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100:
