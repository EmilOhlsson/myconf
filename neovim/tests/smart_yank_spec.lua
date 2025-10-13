-- Unit tests for smart-yank module using plenary.nvim test harness
-- Run with: :PlenaryBustedFile tests/smart_yank_spec.lua

local smart_yank = require('smart-yank')

-- Mock vim functions for controlled testing
local test_results = {}

local function setup_mocks()
    -- Store originals to restore later if needed
    test_results.original_expand = vim.fn.expand
    test_results.original_getpos = vim.fn.getpos
    test_results.original_getline = vim.fn.getline
    test_results.original_setreg = vim.fn.setreg

    -- Mock vim.fn functions
    vim.fn.expand = function(path)
        if path == '%' then return 'test.lua' end
        return 'test.lua'
    end

    vim.fn.getpos = function(mark)
        -- Return different positions based on mark
        if mark == "'<" then return {0, 2, 1, 0} end  -- line 2 (visual start)
        if mark == "'>" then return {0, 4, 1, 0} end  -- line 4 (visual end)
        if mark == "'[" then return {0, 1, 1, 0} end  -- line 1 (operator start)
        if mark == "']" then return {0, 3, 1, 0} end  -- line 3 (operator end)
        return {0, 1, 1, 0}
    end

    vim.fn.getline = function(start, end_line)
        local lines = {
            'function test() {',
            '    return "hello";',
            '    console.log("test");',
            '}'
        }
        if end_line then
            local result = {}
            for i = start, math.min(end_line, #lines) do
                table.insert(result, lines[i])
            end
            return result
        else
            return lines[start] or ''
        end
    end

    vim.fn.setreg = function(register, content)
        test_results.last_register = register
        test_results.last_content = content
    end

    -- Ensure vim.o exists for operatorfunc
    vim.o = vim.o or {}

    -- Mock vim.api for escape sequences - override even if they exist
    test_results.original_replace_termcodes = vim.api.nvim_replace_termcodes
    test_results.original_feedkeys = vim.api.nvim_feedkeys

    vim.api.nvim_replace_termcodes = function(str, from_part, do_lt, special)
        return str  -- Simple mock - just return the string
    end

    vim.api.nvim_feedkeys = function(keys, mode, escape_csi)
        test_results.keys_sent = keys
        test_results.feedkeys_mode = mode
    end
end

local function teardown_mocks()
    -- Clear test results but keep structure
    test_results.last_register = nil
    test_results.last_content = nil
    test_results.keys_sent = nil
    test_results.feedkeys_mode = nil
end

describe('Smart Yank Module', function()
    before_each(function()
        setup_mocks()
    end)

    after_each(function()
        teardown_mocks()
    end)

    describe('Module Loading', function()
        it('should load without errors', function()
            assert.is_not_nil(smart_yank)
            assert.is_table(smart_yank)
        end)

        it('should expose setup function', function()
            assert.is_function(smart_yank.setup)
        end)
    end)

    describe('Setup Function', function()
        it('should create keymaps when called', function()
            -- Call setup
            smart_yank.setup()

            -- Check that keymaps were created
            local oc_map = vim.fn.maparg('<leader>oc', 'n', false, true)
            local or_map = vim.fn.maparg('<leader>or', 'n', false, true)

            assert.is_not_nil(oc_map.lhs, 'Normal mode <leader>oc should be mapped')
            assert.is_not_nil(or_map.lhs, 'Normal mode <leader>or should be mapped')

            local oc_visual = vim.fn.maparg('<leader>oc', 'v', false, true)
            local or_visual = vim.fn.maparg('<leader>or', 'v', false, true)

            assert.is_not_nil(oc_visual.lhs, 'Visual mode <leader>oc should be mapped')
            assert.is_not_nil(or_visual.lhs, 'Visual mode <leader>or should be mapped')
        end)

        it('should accept custom configuration', function()
            smart_yank.setup({
                keymaps = {
                    output_content = 'yc',
                    output_range = 'yr'
                }
            })

            -- Check custom keymaps were created
            local yc_map = vim.fn.maparg('<leader>yc', 'n', false, true)
            local yr_map = vim.fn.maparg('<leader>yr', 'n', false, true)

            assert.is_not_nil(yc_map.lhs, 'Custom <leader>yc should be mapped')
            assert.is_not_nil(yr_map.lhs, 'Custom <leader>yr should be mapped')
        end)

        it('should accept custom register configuration', function()
            smart_yank.setup({
                register = 'a'
            })

            -- This test mainly ensures no errors occur during setup
            assert.is_true(true, 'Setup with custom register should not error')
        end)
    end)

    describe('Integration Test', function()
        it('should work end-to-end with mocked vim functions', function()
            -- Set up the module
            smart_yank.setup()

            -- Get the keymap function for <leader>oc
            local oc_map = vim.fn.maparg('<leader>oc', 'n', false, true)
            assert.is_not_nil(oc_map.callback, 'Keymap should have a callback function')

            -- Simulate pressing <leader>oc (this should set operatorfunc and return 'g@')
            local result = oc_map.callback()
            assert.equals('g@', result, 'Keymap should return g@')

            -- Check that operatorfunc was set to the v:lua pattern
            assert.equals('v:lua.SmartYankContent', vim.o.operatorfunc, 'operatorfunc should be set to v:lua.SmartYankContent')
            -- Check that the global function exists
            assert.is_function(_G.SmartYankContent, 'SmartYankContent global function should exist')

            -- Simulate vim calling the operatorfunc after motion
            local success, err = pcall(_G.SmartYankContent, 'line')
            assert.is_true(success, 'operatorfunc should execute without error: ' .. tostring(err))

            -- Check that content was yanked correctly
            assert.is_not_nil(test_results.last_content, 'Content should be yanked')
            assert.matches('`test%.lua:1,3`', test_results.last_content, 'Should contain file reference')
            assert.matches('```', test_results.last_content, 'Should contain code block markers')
        end)

        it('should work with visual mode selections', function()
            -- Set up the module
            smart_yank.setup()

            -- Get the visual mode keymap function for <leader>oc
            local oc_visual_map = vim.fn.maparg('<leader>oc', 'v', false, true)
            assert.is_not_nil(oc_visual_map.callback, 'Visual keymap should have a callback function')

            -- Simulate visual selection by calling the function directly
            local success, err = pcall(oc_visual_map.callback)
            assert.is_true(success, 'Visual mode function should execute without error: ' .. tostring(err))

            -- Check that content was yanked correctly
            assert.is_not_nil(test_results.last_content, 'Content should be yanked')
            assert.matches('`test%.lua:2,4`', test_results.last_content, 'Should contain visual file reference')
            assert.matches('```', test_results.last_content, 'Should contain code block markers')

            -- Check that escape key was sent to exit visual mode
            assert.is_not_nil(test_results.keys_sent, 'Keys should be sent to exit visual mode')
        end)

        it('should work with range-only output', function()
            -- Set up the module
            smart_yank.setup()

            -- Get the keymap function for <leader>or
            local or_map = vim.fn.maparg('<leader>or', 'n', false, true)
            assert.is_not_nil(or_map.callback, 'Range keymap should have a callback function')

            -- Simulate pressing <leader>or
            local result = or_map.callback()
            assert.equals('g@', result, 'Range keymap should return g@')

            -- Simulate vim calling the operatorfunc after motion
            local success, err = pcall(_G.SmartYankRange, 'line')
            assert.is_true(success, 'Range operatorfunc should execute without error: ' .. tostring(err))

            -- Check that only range was yanked (no code block)
            assert.is_not_nil(test_results.last_content, 'Content should be yanked')
            assert.matches('`test%.lua:1,3`', test_results.last_content, 'Should contain file reference')
            assert.is_nil(string.match(test_results.last_content, '```'), 'Should not contain code block markers')
        end)
    end)
end)

-- vim: set et ts=4 sw=4 ss=4 tw=100 :