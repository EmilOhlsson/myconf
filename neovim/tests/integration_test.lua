#!/usr/bin/env nvim -l

-- Integration test script that runs in a real Neovim instance
-- Usage: nvim -l tests/integration_test.lua

print("Running integration test for smart-yank...")

-- Create a temporary file to test with
local temp_file = vim.fn.tempname() .. '.lua'
local test_content = {
    'function hello() {',
    '    print("Hello World");',
    '    return true;',
    '}'
}

-- Write test content to file
vim.fn.writefile(test_content, temp_file)

-- Open the file
vim.cmd('edit ' .. temp_file)

-- Test 1: Check module loading
print("Test 1: Module loading...")
local ok, smart_yank = pcall(require, 'smart-yank')
if not ok then
    print("❌ FAIL: Could not load smart-yank module: " .. tostring(smart_yank))
    os.exit(1)
end
print("✅ PASS: Module loaded successfully")

-- Test 2: Check setup function exists
print("Test 2: Setup function...")
if type(smart_yank.setup) ~= 'function' then
    print("❌ FAIL: setup is not a function")
    os.exit(1)
end
print("✅ PASS: Setup function exists")

-- Test 3: Test setup function execution
print("Test 3: Setup function execution...")
local success, err = pcall(smart_yank.setup)
if not success then
    print("❌ FAIL: setup() failed: " .. tostring(err))
    os.exit(1)
end
print("✅ PASS: Setup completed without errors")

-- Test 4: Check keymaps were created
print("Test 4: Keymap creation...")
local oc_map = vim.fn.maparg('<leader>oc', 'n', false, true)
if not oc_map.lhs then
    print("❌ FAIL: <leader>oc keymap not created")
    os.exit(1)
end
local or_map = vim.fn.maparg('<leader>or', 'n', false, true)
if not or_map.lhs then
    print("❌ FAIL: <leader>or keymap not created")
    os.exit(1)
end
print("✅ PASS: Keymaps created")

-- Test 5: Test keymap functionality
print("Test 5: Keymap functionality...")
local oc_map = vim.fn.maparg('<leader>oc', 'n', false, true)
local result = oc_map.callback()
if result ~= 'g@' then
    print("❌ FAIL: <leader>oc callback returned: " .. tostring(result))
    os.exit(1)
end
-- Check that operatorfunc was set to the v:lua pattern
if vim.o.operatorfunc ~= 'v:lua.SmartYankContent' then
    print("❌ FAIL: operatorfunc should be v:lua.SmartYankContent, got: " .. tostring(vim.o.operatorfunc))
    os.exit(1)
end
-- Check that the global function exists
if type(_G.SmartYankContent) ~= 'function' then
    print("❌ FAIL: SmartYankContent global function should exist")
    os.exit(1)
end
print("✅ PASS: Keymap functionality works")

-- Test 6: Test operatorfunc call
print("Test 6: Operatorfunc call...")

-- Clear registers first
vim.fn.setreg('"', '')
vim.fn.setreg('+', '')

vim.fn.setpos("'[", {0, 2, 1, 0})  -- Set operator marks
vim.fn.setpos("']", {0, 3, 1, 0})
local ok2, err = pcall(_G.SmartYankContent, 'line')
if not ok2 then
    print("❌ FAIL: operatorfunc call failed: " .. tostring(err))
    os.exit(1)
end
print("✅ PASS: Operatorfunc call succeeded")

-- Test 7: Check register content
print("Test 7: Register content...")
-- Try the configured register first ('+'), then fall back to default ('""')
local register_content = vim.fn.getreg('+')
if not register_content or register_content == '' then
    register_content = vim.fn.getreg('""')  -- Check default register as fallback
end
if not register_content or register_content == '' then
    print("❌ FAIL: No content in any register")
    os.exit(1)
end
if not string.match(register_content, vim.fn.fnamemodify(temp_file, ':t')) then
    print("❌ FAIL: Register doesn't contain expected file reference")
    print("Register content: " .. register_content)
    os.exit(1)
end
if not string.match(register_content, '```') then
    print("❌ FAIL: Register doesn't contain code block markers")
    print("Register content: " .. register_content)
    os.exit(1)
end
print("✅ PASS: Register contains expected content with code block")
print("Register content: " .. register_content)

-- Cleanup
vim.fn.delete(temp_file)

print("🎉 ALL TESTS PASSED!")
print("The smart-yank module is working correctly in a real Neovim environment.")

-- vim: set et ts=4 sw=4 ss=4 tw=100 :