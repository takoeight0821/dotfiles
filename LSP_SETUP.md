# Neovim LSP Setup Guide

## Overview

Your Neovim is now configured with full LSP (Language Server Protocol) support, providing IDE-like features including:

- Intelligent code completion
- Go to definition/references
- Hover documentation
- Code actions and refactoring
- Real-time diagnostics
- Auto-formatting

## First Time Setup

1. Open Neovim: `nvim`
2. Run `:Lazy` to ensure all plugins are installed
3. Run `:Mason` to open the LSP installer
   - Press `g?` for help
   - Install language servers with `i`
   - Common servers: lua_ls, pyright, tsserver, rust_analyzer

## Key Bindings

### LSP Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gI` - Go to implementation
- `gr` - Find references
- `K` - Hover documentation
- `<leader>D` - Type definition
- `<leader>ds` - Document symbols
- `<leader>ws` - Workspace symbols

### Code Actions
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format code

### Diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>e` - Show diagnostic float
- `<leader>q` - Diagnostic list
- `<leader>xx` - Toggle diagnostics (Trouble)

### Completion (Insert Mode)
- `<C-n>` - Next completion item
- `<C-p>` - Previous completion item
- `<C-y>` - Accept completion
- `<C-Space>` - Trigger completion manually
- `<C-l>` - Jump to next snippet placeholder
- `<C-h>` - Jump to previous snippet placeholder

## Installing Language Servers

### Via Mason (Recommended)
1. Run `:Mason` in Neovim
2. Find your language server
3. Press `i` to install

### Manual Installation Examples
```bash
# Python
pip install pyright

# JavaScript/TypeScript
npm install -g typescript typescript-language-server

# Rust
rustup component add rust-analyzer

# Go
go install golang.org/x/tools/gopls@latest

# F#
dotnet tool install -g fsautocomplete
```

### F# Specific Features
- **F# Interactive (FSI)** keybindings:
  - `<leader>fi` - Send current line/selection to FSI
  - `<leader>ft` - Toggle F# Interactive window
  - `<leader>fr` - Reset F# Interactive
- **Ionide-vim** provides enhanced F# support
- **FsAutoComplete** language server for intelligent completion

## Adding New Language Servers

Edit `~/.config/nvim/lua/plugins/lsp.lua` and add to the `servers` table:

```lua
local servers = {
  lua_ls = { ... },
  pyright = {},  -- Python
  tsserver = {},  -- TypeScript/JavaScript
  rust_analyzer = {},  -- Rust
  gopls = {},  -- Go
  fsautocomplete = { ... },  -- F#
  -- Add more servers here
}
```

## Troubleshooting

1. Check LSP status: `:LspInfo`
2. Check Mason status: `:Mason`
3. View logs: `:LspLog`
4. Ensure language server is in PATH

## Format on Save

Format on save is enabled by default. To disable for specific filetypes, edit the `disable_filetypes` table in `~/.config/nvim/lua/plugins/lsp.lua`.

## Testing LSP

1. Open the test file: `nvim test_lsp.lua`
2. Try hovering over `print` and press `K`
3. Place cursor on `greet` and press `gd` to go to definition
4. Type `local test = string.` to test autocompletion