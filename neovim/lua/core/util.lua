local M = {
    -- Attempt to load a module, and return nil if doesn't exist
    try_load = function(module_name)
        local ok, result = pcall(require, module_name)
        if not ok then
            return nil
        end
        return result
    end,

    -- Set a keymap. Every keymap gets a description, extra options go in `opts`
    -- TODO: Consider dropping this in favour of calling vim.keymap.set directly
    map = function(mode, lhs, rhs, description, opts)
        local options = vim.tbl_extend('force', opts or {}, { desc = description })
        vim.keymap.set(mode, lhs, rhs, options)
    end,
}

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
