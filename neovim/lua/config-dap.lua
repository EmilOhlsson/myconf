local utils = require('config-utils')

local dap = utils.try_load('dap')
local dap_widgets = utils.try_load('dap.ui.widgets')

local pick_file = function()
    return vim.fn.input("Pick file: ", vim.fn.getcwd() .. '/', 'file')
end

local function configure_dap()
    -- Assume check in setup function

    assert(dap ~= nil)

    dap.adapters['gdb'] = {
        type = 'executable',
        command = 'gdb',
        args = {
            '--interpreter=dap',
            '--eval-command', 'set pretty print on'
        },
    }
    dap.adapters['python'] = function(cb, config)
        if config.request == 'attach' then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
                type = 'server',
                port = port,
                host = host,
                options = {
                    source_filetype = 'python'
                }
            })
        else
            cb({
                type = 'executable',
                command = 'python',
                args = { '-m', 'debugpy.adapter' },
                options = {
                    source_filetype = 'python'
                }
            })
        end
    end
    local gdb_config = {
        {
            name = 'launch',
            type = 'gdb',
            request = 'launch',
            program = pick_file,
            cwd = "${workspaceFolder}",
        },
        {
            name = 'Attach to GDB server',
            type = 'gdb',
            request = 'attach',
            target = 'localhost:2345',
            program = pick_file,
            cwd = "${workspaceFolder}"
        }
    }
    dap.configurations = {
        c = gdb_config,
        cpp = gdb_config,
        rust = gdb_config,
        python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                pythonPath = function()
                    return '/usr/bin/python'
                end,
            }
        }
    }
end

-- Configure a keyboard shortcut for a given function. Prepend leader key
local function map_key(key, func)
    vim.keymap.set('n', ',' .. key, func)
end

local function set_logging_breakpoint()
    assert(dap ~= nil)
    dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
end

local function configure_dap_keymap()
    assert(dap ~= nil)
    assert(dap_widgets ~= nil)

    map_key(',', dap.step_over)
    map_key('b', dap.toggle_breakpoint)
    map_key('B', set_logging_breakpoint)
    map_key('C', dap.clear_breakpoints)
    map_key('c', dap.continue)
    map_key('d', dap.down)
    map_key('h', dap_widgets.hover)
    map_key('o', dap.step_out)
    map_key('r', dap.repl.toggle)
    map_key('s', dap.step_into)
    map_key('u', dap.up)
end


local M = {
    setup = function()
        if dap ~= nil then
            configure_dap()
            configure_dap_keymap()

            -- Configure virutal text, if possible
            local dap_virtual_text = utils.try_load('nvim-dap-virtual-text')
            if dap_virtual_text ~= nil then
                dap_virtual_text.setup({
                    commented = true
                })
            end
        end
    end
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
