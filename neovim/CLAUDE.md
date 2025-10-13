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