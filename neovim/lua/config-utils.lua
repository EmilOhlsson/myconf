local M = {
    -- Attempt to load a module, and return nil if doesn't exist
    try_load = function(module_name)
        local ok, result = pcall(require, module_name)
        if not ok then
            return nil
        end
        return result
    end
}

return M
