# Tool configurations

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# SSH (macOS specific keychain loading)
if [[ "$OSTYPE" == "darwin"* ]] && command -v ssh-add &>/dev/null; then
    ssh-add --apple-load-keychain 2>/dev/null
fi

# mise (formerly rtx) - runtime version manager
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# FZF
if command -v fzf &>/dev/null; then
    # Set up fzf key bindings and fuzzy completion
    source <(fzf --zsh) 2>/dev/null

    # Install fzf-git.sh if not present
    if [ ! -f ~/.local/share/fzf-git.sh ]; then
        mkdir -p ~/.local/share
        curl -sL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh > ~/.local/share/fzf-git.sh
    fi

    # Source fzf-git.sh if it exists
    if [ -f ~/.local/share/fzf-git.sh ]; then
        source ~/.local/share/fzf-git.sh
    fi
fi

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# direnv (optional)
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi