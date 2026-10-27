return {
    filetypes = { 'lua' },
    cmd = { 'lua-language-server' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true)
            },
        },
    }
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
