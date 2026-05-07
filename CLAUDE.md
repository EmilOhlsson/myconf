# Coding Agent Protocol

## Rule 0
When anything fails: STOP. Explain to Q. Wait for confirmation before proceeding.

## Before Every Action

```
DOING: [action]
EXPECT: [predicted outcome]
IF WRONG: [what that means]
```

Then the tool call. Then compare. Mismatch = stop and surface to Q.

## Checkpoints
Max 3 actions before verifying reality matches your model. Thinking isn't
verification—observable output is.

## Epistemic Hygiene
- "I believe X" ≠ "I verified X"
- "I don't know" beats confident guessing
- One example is anecdote, three is maybe a pattern

## Autonomy Check
Before significant decisions: Am I the right entity to decide this? Uncertain +
consequential → ask Q first. Cheap to ask, expensive to guess wrong.

## Context Decay
Every ~10 actions: verify you still understand the original goal. Say "losing
the thread" when degraded.

## Chesterton's Fence
Can't explain why something exists? Don't touch it until you can.

## Handoffs
When stopping: state what's done, what's blocked, open questions, files touched.

## Communication
When confused: stop, think, present theories, get signoff. Never silently retry
failures.

# Repository Structure

This is a personal dotfiles/configuration repository managed with
[dotbot](https://github.com/anishathalye/dotbot). `install.conf.yaml` defines
which files get symlinked into `$HOME`.

## Root-level dotfiles

Configs symlinked directly into `$HOME` or `$XDG_CONFIG_HOME`:

| File | Destination |
|---|---|
| `alacritty.yml` | `~/.alacritty.yml` |
| `bashrc` | shell-sourced manually |
| `clang-format` | `~/.clang-format` |
| `clangd` | clangd LSP config |
| `common.sh` | shared shell helpers, sourced by `zshrc`/`bashrc` |
| `gitconfig` | git config |
| `guile.scm` | `~/.guile` (Guile Scheme REPL) |
| `init.vim` | `~/.config/nvim/init.vim` |
| `kitty.conf` | `~/.config/kitty/kitty.conf` |
| `LS_COLORS` | ls colour scheme, sourced by shell |
| `tmux.conf` | `~/.tmux.conf` |
| `vimrc` | Vim config |
| `Xresources` | X11 resources |
| `zshrc` | Zsh config, appended to `~/.zshrc` by installer |

`*.sample` files are templates for machine-local overrides — copy without the
`.sample` suffix and they are gitignored.

## Directories

| Directory | Purpose |
|---|---|
| `configs/` | Miscellaneous system files: udev rules (`*.rules`), synaptics override, and one-off scripts that don't fit elsewhere |
| `darktable/` | Darktable photo editor configuration and Lua scripts |
| `docs/` | Personal reference documentation (building Vim/Neovim, common commands, etc.) |
| `dotbot/` | Git submodule — dotbot installer tool |
| `dotbot-omnipkg/` | Git submodule — dotbot plugin for cross-platform package management |
| `lua/` | Standalone Lua scripts (theme generation, colour utilities) |
| `neovim/` | Neovim configuration (`after/`, `lua/`, `plugged/`, `templates/`) |
| `oh-my-zsh/` | Git submodule — Oh My Zsh framework |
| `scripts/` | Shell scripts and automation helpers |
| `templates/` | Project starter templates (`cpp-cmake`, `nvim-plugin`, `python-util`) |
| `tools/` | Tool-specific build/install helpers (`fzf`, `ghostty`, `neovim`) |
| `vim/` | Vim configuration (`after/`, `bundle/`, `plugin/`, etc.) |
| `xdg/` | XDG config entries: `ghostty`, `sway`, `waybar`, `wezterm`, `wofi` |
| `zsh-custom/` | Custom Oh My Zsh plugins and themes |

<!-- vim: set et ts=2 sw=2 ss=2 tw=80 nowrap spell: -->
