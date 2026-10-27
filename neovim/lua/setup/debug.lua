local map = require('core.util').map

local pick_file = function()
    return vim.fn.input('Pick file: ', vim.fn.getcwd() .. '/', 'file')
end

local function configure_dap(dap)
    dap.adapters['gdb'] = {
        type = 'executable',
        command = 'gdb',
        args = {
            '--interpreter=dap',
            '--eval-command', 'set pretty print on'
        },
    }
    dap.adapters['lldb'] = {
        type = 'executable',
        command = vim.fn.exepath('lldb-dap'),
        name = 'lldb',
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
    local native_config = {
        {
            name = 'launch in GDB',
            type = 'gdb',
            request = 'launch',
            program = pick_file,
            cwd = '${workspaceFolder}',
        },
        {
            name = 'Attach to GDB server',
            type = 'gdb',
            request = 'attach',
            target = 'localhost:2345',
            program = pick_file,
            cwd = '${workspaceFolder}'
        },
        {
            name = 'launch in LLDB',
            type = 'lldb',
            request = 'launch',
            program = pick_file,
            cwd = '${workspaceFolder}',
        },
    }
    dap.configurations = {
        c = native_config,
        cpp = native_config,
        rust = native_config,
        python = {
            {
                name = 'Launch file',
                type = 'python',
                request = 'launch',
                program = '${file}',
                pythonPath = function()
                    return vim.fn.exepath('python')
                end,
            }
        }
    }
end

-- Configure a keyboard shortcut for a given function. Prepend leader key
local function map_key(key, func, description)
    map('n', ',' .. key, func, 'Debug: ' .. description)
end

local function configure_dap_keymap(dap)
    local dap_widgets = require('dap.ui.widgets')

    local function set_logging_breakpoint()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
    end

    local function set_conditional_breakpoint()
        dap.set_breakpoint(vim.fn.input('Break condition: '), nil, nil)
    end

    map_key(',', dap.step_over, 'step over')
    map_key('b', dap.toggle_breakpoint, 'toggle breakpoint')
    map_key('B', set_logging_breakpoint, 'set logging breakpoint')
    map_key('C', dap.clear_breakpoints, 'clear all breakpoints')
    map_key('c', dap.continue, 'continue/start execution')
    map_key('d', dap.down, 'down one frame')
    map_key('e', set_conditional_breakpoint, 'set conditional breakpoint')
    map_key('h', dap_widgets.hover, 'hover expression')
    map_key('o', dap.step_out, 'step out')
    map_key('r', dap.repl.toggle, 'toggle REPL')
    map_key('s', dap.step_into, 'step into')
    map_key('t', dap.terminate, 'terminate')
    map_key('u', dap.up, 'up one frame')
end

local function configure_dap_signs()
    local function define(sign, icon)
        vim.fn.sign_define(sign, {
            text = icon,
            texthl = sign,
            linehl = sign .. 'Line',
            culhl = sign .. 'CurrentLine',
        })
    end
    -- TODO: try to read from nvim-web-devicons
    define('DapBreakpointCondition', '\u{29bf}')
    define('DapBreakpoint', '\u{29bf}')
    define('DapStopped', '\u{23f5}')
end

return {
    {
        module = 'dap',
        setup = function(dap)
            configure_dap(dap)
            configure_dap_keymap(dap)
            configure_dap_signs()
        end,
    },
    {
        module = 'nvim-dap-virtual-text',
        setup = function(dap_virtual_text)
            dap_virtual_text.setup({
                enabled = false,            -- Disable by default, can be verbose
                commented = true,           -- Use language comment style
                enabled_commands = true,    -- Allow toggle using command
            })
        end,
    },
    {
        module = 'dapui',
        setup = function(dap_ui)
            dap_ui.setup()
            map_key('U', dap_ui.toggle, 'toggle UI')
        end,
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
