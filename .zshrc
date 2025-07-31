# Zsh Configuration
# This file sources modular configuration files from ~/.config/zsh/

# Set config directory
export ZSH_CONFIG_DIR="${HOME}/.config/zsh"

# Source modular configuration files in order
for config_file in "${ZSH_CONFIG_DIR}"/*.zsh; do
    # Skip example files
    if [[ "$(basename "$config_file")" != *".example" ]] && [[ -f "$config_file" ]]; then
        source "$config_file"
    fi
done

# Add user's local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Set default editor (can be overridden in local.zsh)
export EDITOR="${EDITOR:-vim}"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/y002168/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
