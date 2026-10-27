--- Bootstrap: everything later modules assume is set up here, in a fixed order.

local M = {}

local root = vim.fn.stdpath('config')

--- Paths used by the rest of the config. Use these instead of guessing from 'runtimepath'
M.paths = {
    root = root,                                                -- This config directory
    templates = root .. '/templates',                           -- Skeleton files for new buffers
    pack = vim.fn.stdpath('data') .. '/site/pack/core/opt',     -- Where vim.pack installs plugins
    local_cfg = root .. '/local.lua',                           -- Per-machine config, gitignored
    local_rt = root .. '/local',                                -- Per-machine runtime dir, gitignored
}

--- Content of local.lua, see local.lua.sample. Empty if there is no local.lua
M.local_cfg = {}

--- Prepend a runtime directory, and append its after/ directory if there is one
local function add_rtp(dir)
    vim.opt.rtp:prepend(dir)
    if vim.fn.isdirectory(dir .. '/after') == 1 then
        vim.opt.rtp:append(dir .. '/after')
    end
end

--- Make the per-machine runtime dir take part in the normal runtime lookups
local function setup_local_rt()
    if vim.fn.isdirectory(M.paths.local_rt) == 1 then
        add_rtp(M.paths.local_rt)
    end
end

--- Profile startup if `PROF` is set to truthy value
local function setup_profiler()
    if not vim.env.PROF then
        return
    end
    local snacks = M.paths.pack .. '/snacks.nvim'
    if not vim.uv.fs_stat(snacks) then
        vim.notify('PROF is set, but snacks.nvim is not installed in ' .. M.paths.pack,
            vim.log.levels.WARN)
        return
    end
    vim.opt.rtp:append(snacks)
    ---@diagnostic disable-next-line: missing-fields
    require('snacks.profiler').startup({
        startup = {
            event = 'VimEnter',
        }
    })
end

--- Make sure that we're aware of the color theme
local function setup_background()
    vim.g.background = vim.env.BACKGROUND == 'light' and 'light' or 'dark'
    vim.o.background = vim.g.background
end

--- Load local.lua, if there is one
local function load_local_cfg()
    if vim.fn.filereadable(M.paths.local_cfg) == 0 then
        return
    end
    M.local_cfg = dofile(M.paths.local_cfg)
end

--- Use working trees of plugins under development in place
local function setup_dev_plugins()
    for _, dir in ipairs(M.local_cfg.dev or {}) do
        local path = vim.fn.expand(dir)
        assert(vim.fn.isdirectory(path) ~= 0)
        add_rtp(path)
    end
end

M.setup = function()
    setup_local_rt()
    setup_profiler()
    setup_background()
    load_local_cfg()
    setup_dev_plugins()
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
