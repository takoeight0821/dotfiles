# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository for managing personal development environment configurations. The repository uses symbolic links to deploy configurations while keeping all files in the git repository.

## Key Commands

### Setup and Installation

```bash
# Install dotfiles (creates symlinks, backs up existing files)
./setup.sh

# Preview changes without making them
./setup.sh --dry-run

# Remove dotfile symlinks
./setup.sh --uninstall

# Manual force mode (skip confirmations)
./setup.sh --force

# Interactive mode (prompt before overwriting)
./setup.sh --no-force
```

### Working with the Repository

```bash
# After making configuration changes
git add .
git commit -m "Update configuration"
git push

# Apply changes after pulling updates
./setup.sh
```

## Architecture

### Directory Structure

- **`.zshrc`**: Entry point that sources modular configs from `~/.config/zsh/`
- **`.config/zsh/`**: Modular Zsh configuration with numbered files for load order:
  - `10-tools.zsh`: Tool initialization (Nix, Homebrew, mise, FZF, Starship, direnv)
  - `20-functions.zsh`: Custom shell functions
  - `30-aliases.zsh`: Git and command aliases
  - `40-keybindings.zsh`: Vi mode and custom keybindings
  - `99-local.zsh`: Machine-specific settings (not tracked in git)
  - `99-local.zsh.example`: Template for local configuration
- **`.config/nvim/`**: Neovim configuration with lazy.nvim:
  - `init.lua`: Entry point
  - `lua/config/`: Core configuration (lazy.nvim bootstrap, options, keymaps, autocmds)
  - `lua/plugins/`: Plugin specifications
  - `lua/plugins/lsp.lua`: LSP configuration
  - `lua/plugins/cmp.lua`: Autocompletion configuration
- **`.config/mise/`**: Runtime version manager configuration
- **`.claude/settings.local.json`**: Claude-specific permissions

### Setup Script Architecture

The `setup.sh` script:
1. Creates `~/.dotfiles-backup/` with timestamp for existing file backups
2. Iterates through all files/directories (excluding .git, README, setup.sh)
3. Creates parent directories as needed
4. Creates symbolic links from home directory to repository files
5. Handles special cases like the local configuration template

### Configuration Philosophy

- **Modular**: Configurations split by concern with numbered priority loading
- **Non-destructive**: Always backs up existing files before overwriting
- **Platform-aware**: Conditional loading for macOS/Linux-specific features
- **Tool-agnostic**: Only configures tools if they're installed

## Important Notes

- Use `trash` command instead of `rm` for file deletion (per user's global CLAUDE.md)
- Local machine-specific settings should go in `99-local.zsh` (not committed to git)
- The repository assumes Zsh as the default shell
- Tool configurations are loaded conditionally - missing tools won't cause errors

## F# Development

The Neovim configuration includes full F# support via:
- **Ionide-vim**: F# language plugin
- **FsAutoComplete**: F# language server (must be installed manually with `dotnet tool install -g fsautocomplete`)
- **nvim-treesitter**: Syntax highlighting for F# 
- **nvim-lspconfig**: LSP integration
- **nvim-cmp**: Autocompletion

F# Interactive (FSI) is available through Neovim's terminal with special keybindings for sending code to FSI.
