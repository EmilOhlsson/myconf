# Architecture Overview

This is a personal Neovim configuration that is written to support different local configurations.
No assumptions about which plugins are actually available are made. It's set up by symlinking
`~/.config/nvim` to this directory.

The overall structure looks like this

- `init.lua`: Entry point. Runs bootstrap, core setup, packages, theme and LSP, and then loads every
  plugin spec
- `lua/core/`: `bootstrap.lua` (paths, `local.lua`, dev plugins, `$PROF`, `$BACKGROUND`),
  `options.lua`, `keymaps.lua` and `autocmds.lua` (plugin-independent setup), `pack.lua` (the
  `vim.pack` package list) and `util.lua` (`try_load()` and `map()`)
- `lua/setup/`: Plugin setup, one file per area (`ui.lua`, `language.lua`, `debug.lua`, `git.lua`).
  Every file is loaded, and each returns a list of plugin specs
- `lua/plugins/`: Own plugins (smart-yank, visual-match, git-conflict)
- `lua/theme/`: `mini-theme.lua`, with `fallback.lua` when mini.nvim isn't installed
- `lua/lsp/init.lua` and `lsp/<server>.lua`: Native LSP. Every server with a file in `lsp/` is
  enabled, and an `LspAttach` handler sets up keymaps, completion and reference highlighting
- `ftplugin/`: Filetype settings
- `local.lua` and `local/`: Gitignored, per-machine config. See `local.lua.sample` and
  `:help my-local-config`

## Plugin specs and error handling

A spec is `{ module = 'gitsigns', setup = function(gitsigns) ... end }`. The module is loaded with
`core.util.try_load()`, which silently returns `nil` on any error, so a missing or broken third-party
plugin is skipped. Bugs in own code must fail loudly instead: specs for own plugins have no `module`
and their `setup()` is always called, and neither `setup()` functions, `local.lua` nor its hooks are
ever wrapped in `pcall`. Don't add custom checks where a normal crash already shows the problem.

# Key Configuration

- **LSP Configuration** (`lsp/*.lua`, `lua/lsp/init.lua`): Native Neovim 0.11+ LSP with servers for
  C/C++ (clangd), Python (pylsp), Lua (lua_ls), and ARM assembly (armls). Project-specific settings
  go in a trusted `.nvim.lua` calling `vim.lsp.config()` (see `:help my-lsp-setup`)
- **Theming**: mini-theme, or the fallback highlights when `mini.colors` isn't available
- **Plugin Management**: `vim.pack`, with heavy use of snacks.nvim (picker/explorer), mini.nvim
  modules, treesitter, and DAP

# Development Notes

- Configuration expects `$BACKGROUND` environment variable for theme detection
- Supports per-machine config via `local.lua` (extra packages, dev plugins, hooks) and `local/`
  (spec files, LSP servers and overrides, ftplugins)
- Uses skeleton templates from `templates/` directory for new files
- Profiling available by setting `PROF=1` environment variable

# Static Analysis

The repository includes a `.luarc.json` configuration file for the Lua Language Server to enable
static analysis of Lua configuration files.

## Running Static Analysis

To perform static analysis on the Lua files:

```bash
# Check all Lua files in the config (init.lua, lua/, ftplugin/, ...)
lua-language-server --check . --checklevel=Warning
```

The check must report no problems.

## Configuration

The `.luarc.json` file configures:
- **Runtime**: LuaJIT (used by Neovim)
- **Workspace**: `$VIMRUNTIME/lua` and the luv type definitions as libraries, without the
  third-party library prompt
- **Diagnostics**: Recognizes `vim` as a global variable
- **Telemetry**: Disabled

# Coding Standards

There's no formatter config: **don't run an auto-formatter**, since it would destroy the column
alignment described below.

## Lua Files

All Lua configuration files should include the following modeline at the end:
```lua
-- vim: set et ts=4 sw=4 ss=4 tw=100 :
```

- 4 spaces, no tabs, `textwidth` 100. Highlight tables are the one exception (see below)
- Single-quoted strings. Use `[[...]]` when the string contains quotes or backslashes
- Don't nest calls inside a loop header. Assign the result to a named local first:
  ```lua
  local files = vim.fn.glob(dir .. '/lua/setup/*.lua', false, true)
  for _, file in ipairs(files) do
  ```
- `vim.fn` functions return Vimscript numbers, and `0` is truthy in Lua. Compare explicitly
  (`vim.fn.isdirectory(path) == 1`)
- File and module names use hyphens (`smart-yank`)

## Modules

- `local M = {}` … `return M`. Helpers are `local function`, and nothing is global unless Neovim
  requires it (like the `v:lua` operatorfunc in `smart-yank.lua`, with a comment saying why)
- Own plugins follow `smart-yank.lua`: a `---` doc header (purpose, usage, keymaps it creates),
  `---@alias` types for options, a `DEFAULT_CONFIG` table, and `M.setup(opts)`. They only use the
  Neovim API, not this config's helpers, so they can move to their own repos
- Merge options with `vim.tbl_deep_extend('force', DEFAULT_CONFIG, opts or {})`, but only for
  map-like tables. It merges lists **by index** (`{1,2,3}` + `{9}` gives `{9,2,3}`), so list-valued
  options must be replaced or appended explicitly
- Spec files keep a plugin's keymaps inside its `setup`. Helpers shared by several specs in a file
  go at the top of the file as `local function` (as in `debug.lua`)

## Options

One option per line, with a trailing comment aligned in a column within the block:

```lua
vim.o.hlsearch = true               -- Highlight search results
vim.o.incsearch = true              -- Search as you type
```

Leave the comment out only when the option name says it all (`vim.o.signcolumn = 'yes'`).

## Keymaps

- Every map has a `desc`, so `<space>fk` (the keymap picker) is the reference
- Descriptions read `'Domain: action'` when the map belongs to a group (`'Debug: step over'`), and
  are a plain sentence otherwise (`'Move line up'`)
- Group maps under a short comment header (`-- Tab navigation`)
- Prefixes, by domain:

  | Prefix | Used for |
  |---|---|
  | `<space>` | snacks pickers (`'Pick: ...'`) |
  | `\` (leader) | LSP (buffer-local), Termdebug (`\d*`), smart-yank (`\o*`), render-markdown, swap |
  | `,` | DAP (`'Debug: ...'`) |
  | `;` | gitsigns (`;h*`), git-conflict (`;r*`) |
  | `[x`/`]x` | motions: `t` tabs, `h` hunks, `r` conflict panes, `e` errors, `m` functions, `,` parameters. Neovim's own `[q`/`[l`/`[a`/`[d` defaults are kept |
  | `<C-*>` | toggles and actions: `c-b` explorer, `c-f` FloatTerm, `c-h` Highlighter, `c-j` make |

## Comments

- Explain *why* or *what to watch out for*, not what the next line does
- Use `NOTE:` for durable explanations and `TODO:` for known follow-ups
- Use LuaCATS annotations (`---@param`, `---@return`) on non-trivial functions
- Install and setup explanations go in the README, not in code comments

## Highlight tables

Highlight definitions are reference data that gets scanned more than read, so they're laid out for
scanning (`lua/theme/fallback.lua`, `lua/theme/mini-theme.lua`):

- **One group per line.** Never wrap a definition, even past 100 columns. A wrapped entry breaks
  the columns
- **Align `=` in one column** for the whole table, or at least the whole comment-delimited block.
  Pad the key, not the value
- **Align the inner fields too** when neighbouring lines share a structure, so the varying part sits
  in a column:
  ```lua
  LineNr       = { fg = { h = hues.base,   p = props.fg_subtle } },
  CursorLineNr = { fg = { h = hues.orange, p = props.fg_muted }, gui = 'bold' },
  ```
- **Group with a comment header** (`-- UI elements`, `-- LSP symbol references`) and separate groups
  with a blank line
- **Keys:** use bare identifiers for plain group names (`Normal`). Use `['@capture.name']` for
  anything with `@` or `.` in it. Within a table, pick one style when every key allows it
- **Property order:** `fg`, `bg`, then attributes (`gui` or `bold`/`italic`/`underline`). `link`
  stands alone (`Conditional = { link = 'Statement' }`)
- **Prefer `link`** over repeating a definition
- **Commented-out entries keep the alignment**, so they can be re-enabled without reformatting
- Palette tables (`hues`, `props`) follow the same rules: aligned values, a trailing comment with
  the purpose, and grouped by role (`-- Backgrounds`, `-- Foregrounds`)

<!-- vim: set et ts=4 sw=4 ss=4 tw=100 : -->
