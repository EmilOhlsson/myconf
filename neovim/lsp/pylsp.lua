return {
    filetypes = { 'python' },
    cmd = { 'pylsp' },
    settings = {
        pylsp = {
            plugins = {
                pylint = {
                    enabled = true
                },
                pycodestyle = {
                    enabled = true,
                    ignore = 'E501',
                    maxlinelength = 120,
                },
            },
        },
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
