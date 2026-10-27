return {
    cmd = { vim.fn.exepath('armls'), },
    filetypes = { 'asm' },
    settings = {
        armls = {
            diagnostics = {
                enable = false,
            },
            externalDiagnostics = {
                clang = {
                    path = vim.fn.exepath('clang'),
                    args = { '--target=aarch64' },
                },
            },
        },
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
