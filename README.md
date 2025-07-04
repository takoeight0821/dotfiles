This repository contains a collection of dot files for various applications and tools, including:

- Zsh (with modular configuration)
- Git

## Setup

### Quick Setup (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/takoeight0821/dotfiles.git
   cd dotfiles
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

The setup script will:
- Create symbolic links for all dotfiles
- Backup any existing files before overwriting (force mode is default)
- Create a local configuration file from the template

### Setup Script Options

```bash
./setup.sh --help      # Show help
./setup.sh --dry-run   # Preview changes without making them
./setup.sh --force     # Skip confirmation prompts (default behavior)
./setup.sh --no-force  # Prompt before overwriting existing files
./setup.sh --uninstall # Remove dotfile symlinks
```

### Manual Setup

If you prefer to set up manually:

1. Create symbolic links:
   ```bash
   ln -sf "$PWD/.zshrc" ~/.zshrc
   ln -sf "$PWD/.config/zsh" ~/.config/zsh
   ```

2. Copy and customize the local configuration:
   ```bash
   cp .config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
   # Edit ~/.config/zsh/99-local.zsh to add machine-specific settings
   ```

3. Restart your shell or run:
   ```bash
   source ~/.zshrc
   ```

## Zsh Configuration Structure

The Zsh configuration is modularized for better organization and maintainability:

- `.zshrc` - Main configuration file that sources modular configs
- `.config/zsh/10-tools.zsh` - Tool-specific configurations (fzf, starship, etc.)
- `.config/zsh/20-functions.zsh` - Custom shell functions
- `.config/zsh/30-aliases.zsh` - Command aliases
- `.config/zsh/40-keybindings.zsh` - Vi mode and key bindings
- `.config/zsh/99-local.zsh` - Machine-specific settings (not tracked in git)
- `.config/zsh/99-local.zsh.example` - Template for local configuration

Files are numbered to ensure proper load order:
1. Tools and environment setup (10-)
2. Function definitions (20-)
3. Aliases that may use functions (30-)
4. Key bindings that may reference functions (40-)
5. Local overrides load last (99-)

## Dependencies

The configuration includes optional support for:
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep alternative
- [ghq](https://github.com/x-motemen/ghq) - Git repository manager
- [starship](https://starship.rs/) - Cross-shell prompt
- [mise](https://mise.jdx.dev/) - Runtime version manager
- [direnv](https://direnv.net/) - Environment variable manager

Install these tools based on your needs for full functionality.
