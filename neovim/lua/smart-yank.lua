--- Smart Yank - Generate markdown-friendly file references with content
---
--- This module provides functionality to yank file references in markdown-friendly formats.
--- It supports both operator-pending mode (with text objects/motions) and visual mode selections.
---
--- @author Claude Code Assistant
--- @version 1.0
---
--- Usage:
---   require('smart-yank').setup()
---
--- Keymaps created (default):
---   <leader>oc{motion} - Output Content: Yank with code block (e.g., <leader>ocip, <leader>oc5j)
---   <leader>or{motion} - Output Range: Yank range reference only
---   <leader>oc (visual) - Output Content: Yank selected content with code block
---   <leader>or (visual) - Output Range: Yank selected range reference only
---
--- Output formats:
---   Range only: `relative/path/file.lua:10,25`
---   With content:
---   ```
---   `relative/path/file.lua:10,25`
---   ```
---   function example() {
---       return "hello world";
---   }
---   ```
---   ```
---
--- Register support:
---   - Default: System clipboard ('+' register)
---   - Custom: Use register prefix (e.g., "a<leader>oc5j stores in 'a' register)

local M = {}

--- Default configuration options
local DEFAULT_CONFIG = {
    leader = '<leader>',
    keymaps = {
        output_content = 'oc',  -- <leader>oc
        output_range = 'or'     -- <leader>or
    },
    register = '+' -- default to system clipboard
}

--- Module configuration (set during setup)
local config = {}

--- Get line range from vim marks
--- @param start_mark string The starting mark (e.g., "'[", "'<")
--- @param end_mark string The ending mark (e.g., "']", "'>")
--- @return number, number start_line, end_line
local function get_range_from_marks(start_mark, end_mark)
    local start_pos = vim.fn.getpos(start_mark)
    local end_pos = vim.fn.getpos(end_mark)
    return start_pos[2], end_pos[2]
end

--- Get the appropriate register to use
--- @return string register The register to use for yanking
local function get_register()
    -- Check if user specified a register (e.g., "a<leader>oc)
    -- vim.v.register contains the register if one was specified
    return vim.v.register or config.register
end

--- Format the file reference with line numbers
--- @param start_line number Starting line number
--- @param end_line number Ending line number
--- @return string formatted_reference The markdown-formatted file reference
local function format_file_reference(start_line, end_line)
    local path = vim.fn.expand('%')
    if start_line == end_line then
        return '`' .. path .. ':' .. start_line .. '`'
    else
        return '`' .. path .. ':' .. start_line .. ',' .. end_line .. '`'
    end
end

--- Yank content with code block - operator function for <leader>oc
--- This function is called by vim's operator system after motion is provided
--- @param type string The motion type: "line", "char", or "block"
local function yank_content_op(type)
    local start_line, end_line

    -- Get range based on motion type - vim sets '[ and '] marks
    start_line, end_line = get_range_from_marks("'[", "']")

    -- Get the selected content
    local lines = vim.fn.getline(start_line, end_line)
    local content = table.concat(lines, '\n')

    -- Format result with file reference and code block
    local file_ref = format_file_reference(start_line, end_line)
    local result = file_ref .. '\n```\n' .. content .. '\n```'

    -- Store in appropriate register
    local register = get_register()
    vim.fn.setreg(register, result)

    -- User feedback
    print('Yanked content to register ' .. register .. ': ' .. file_ref)
end

--- Yank range reference only - operator function for <leader>or
--- @param type string The motion type: "line", "char", or "block"
local function yank_range_op(type)
    local start_line, end_line = get_range_from_marks("'[", "']")
    local result = format_file_reference(start_line, end_line)

    local register = get_register()
    vim.fn.setreg(register, result)

    print('Yanked range to register ' .. register .. ': ' .. result)
end

--- Yank content with code block - visual mode function
local function yank_content_visual()
    local start_line, end_line = get_range_from_marks("'<", "'>")

    local lines = vim.fn.getline(start_line, end_line)
    local content = table.concat(lines, '\n')

    local file_ref = format_file_reference(start_line, end_line)
    local result = file_ref .. '\n```\n' .. content .. '\n```'

    local register = get_register()
    vim.fn.setreg(register, result)

    print('Yanked content to register ' .. register .. ': ' .. file_ref)

    -- Exit visual mode like normal yank operations
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

--- Yank range reference only - visual mode function
local function yank_range_visual()
    local start_line, end_line = get_range_from_marks("'<", "'>")
    local result = format_file_reference(start_line, end_line)

    local register = get_register()
    vim.fn.setreg(register, result)

    print('Yanked range to register ' .. register .. ': ' .. result)

    -- Exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

--- Setup function to initialize the smart-yank module
--- @param opts? table Optional configuration table
--- @param opts.leader? string Leader key prefix (default: '<leader>')
--- @param opts.keymaps? table Custom keymap definitions
--- @param opts.register? string Default register (default: '+')
function M.setup(opts)
    -- Merge user options with defaults
    config = vim.tbl_deep_extend('force', DEFAULT_CONFIG, opts or {})

    local leader = config.leader
    local km = config.keymaps

    -- Set up global functions for operatorfunc (using fixed names with v:lua pattern)
    -- These functions must be globally accessible for vim.o.operatorfunc to work
    _G.SmartYankContent = yank_content_op
    _G.SmartYankRange = yank_range_op

    -- Set up normal mode operator-pending keymaps
    -- These set the operatorfunc and return 'g@' to start operator mode
    vim.keymap.set('n', leader .. km.output_content, function()
        vim.o.operatorfunc = 'v:lua.SmartYankContent'
        return 'g@'
    end, {
        expr = true,
        desc = 'Output content with movement (e.g., ' .. leader .. km.output_content .. 'ip, ' .. leader .. km.output_content .. '5j)'
    })

    vim.keymap.set('n', leader .. km.output_range, function()
        vim.o.operatorfunc = 'v:lua.SmartYankRange'
        return 'g@'
    end, {
        expr = true,
        desc = 'Output range with movement (e.g., ' .. leader .. km.output_range .. 'ip)'
    })

    -- Set up visual mode keymaps
    vim.keymap.set('v', leader .. km.output_content, yank_content_visual, {
        desc = 'Output content from visual selection'
    })

    vim.keymap.set('v', leader .. km.output_range, yank_range_visual, {
        desc = 'Output range from visual selection'
    })
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :