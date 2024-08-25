local utils = require('config-utils')

local dap = utils.try_load('dap')
local dap_widgets = utils.try_load('dap.ui.widgets')

local pick_file = function()
    return vim.fn.input("Pick file: ", vim.fn.getcwd() .. '/', 'file')
end

local function configure_dap()
    -- Assume check in setup function

    assert(dap ~= nil)
    -- TODO: Configure python debugger

    dap.adapters.gdb = {
        type = 'executable',
        command = 'gdb',
        args = {
            '--interpreter=dap',
            '--eval-command', 'set pretty print on'
        },
    }
    local lang_config = {
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
        c = lang_config,
        cpp = lang_config,
        rust = lang_config,
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
        end
    end
}

return M
