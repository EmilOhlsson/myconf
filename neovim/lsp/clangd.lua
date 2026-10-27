return {
    filetypes = { 'c', 'cpp' },
    cmd = {
        'clangd',
        '--query-driver', '/usr/bin/*g++,/usr/bin/*gcc', -- Allow query of some compilers
        '-j=16',                                         -- Use more threads
        '--completion-style=bundled',                    -- Include more information
        '--enable-config',                               -- Allow configuration
        '--background-index',                            -- Index in background, store to file
        '--header-insertion=iwyu',                       -- Include what you use
        '--pch-storage=memory',                          -- Boost perf for precomiled headers
        '--header-insertion-decorators',                 -- Decorete completions that add headers
    },
}

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
