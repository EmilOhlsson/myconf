# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal Neovim configuration that follows a modular structure:

- **init.vim**: Entry point that sets up runtime paths, background detection, and sources all configuration files
- **plugins.vim**: Plugin management using vim-plug with LSP, treesitter, debugging, and modern UI plugins
- **settings.vim**: Core Vim/Neovim settings including keybindings, editor behavior, and terminal configuration
- **lua/config.lua**: Main Lua configuration orchestrating plugin setup with fallback handling
- **lua/config-*.lua**: Modular configuration files for specific functionality (LSP, treesitter, DAP)

The configuration uses a defensive plugin loading strategy via `config-utils.lua:try_load()` to gracefully handle missing plugins.

## Key Configuration Modules

- **LSP Configuration** (`lua/config-lsp.lua`): Uses native Neovim 0.11+ LSP with servers for C/C++ (clangd), Rust, Python (pylsp), Lua, and ARM assembly
- **Theming**: Hierarchical theme loading - Lush theme → mini-theme → fallback highlights
- **Plugin Management**: Heavy use of modern plugins like snacks.nvim (picker/explorer), mini.nvim modules, treesitter, and DAP

## Important Key Mappings

- **LSP**: `\` prefix for most LSP commands (`\ld` = go to definition, `\lr` = references, `\rn` = rename)
- **File Navigation**: `<space>ff` = file picker, `<space>lg` = live grep, `<c-b>` = file explorer
- **Git**: `]h`/`[h` = next/prev hunk, `;hs` = stage hunk, `;hr` = reset hunk
- **Diagnostics**: `]e`/`[e` = next/prev diagnostic, `\ee` = show diagnostic float
- **Build**: `<c-j>` = run make command

## Development Notes

- Configuration expects `$BACKGROUND` environment variable for theme detection
- Supports local overrides via `~/myconf/local.vim` and `~/myconf/local-plugins.vim`
- Uses skeleton templates from `templates/` directory for new files
- Profiling available by setting `PROF=1` environment variable

## Static Analysis

The repository includes a `.luarc.json` configuration file for the Lua Language Server to enable static analysis of Lua configuration files.

### Running Static Analysis

To perform static analysis on the Lua files:

```bash
# Check all Lua files in the lua/ directory
lua-language-server --check lua/ --checklevel=Warning

# Check a specific file
lua-language-server --check lua/config.lua --checklevel=Warning

# Check with more verbose output (includes Information level)
lua-language-server --check lua/ --checklevel=Information
```

### Configuration

The `.luarc.json` file configures:
- **Runtime**: LuaJIT (used by Neovim) with standard Lua path resolution
- **Workspace**: Includes third-party libraries (luv, busted, luassert) for testing and async operations
- **Diagnostics**: Recognizes `vim` as a global variable and disables false positives for Neovim's dynamic API
- **Hints**: Enables inlay hints for types and parameters when using LSP in editor

The configuration disables `undefined-field` warnings since Neovim's API is highly dynamic and many fields are defined at runtime.

## Coding Standards

### Lua Files
All Lua configuration files should include the following modeline at the end:
```lua
-- vim: set et ts=4 sw=4 ss=4 tw=100 :
```

This ensures consistent formatting with:
- `et` (expandtab): Use spaces instead of tabs
- `ts=4` (tabstop): Tab width of 4 spaces
- `sw=4` (shiftwidth): Indent width of 4 spaces
- `ss=4` (softtabstop): Soft tab stop of 4 spaces
- `tw=100` (textwidth): Line wrap at 100 characters