return {
    -- Apply a function to all entries in a table
    map_tbl = function(fn, tbl)
        local result = {}
        for i, v in ipairs(tbl) do
            result[i] = fn(v)
        end
        return result
    end,
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
