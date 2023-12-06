# Install zplug if not installed
if [ ! -d ~/.zplug ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi


zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "themes/robbyrussell", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose

# Path and other environment variables

typeset -U path PATH fpath

path=($path)

fpath=($fpath)

# Setup GOROOT
# https://github.com/asdf-community/asdf-golang/tree/33b1f6d73a408b32dee8c93b1763c0ba102ee45d#goroot
source ~/.asdf/plugins/golang/set-env.zsh