# # Path to your oh-my-zsh installation.
# export ZSH=/Users/konoyuya/.oh-my-zsh

# # Set name of the theme to load.
# # Look in ~/.oh-my-zsh/themes/
# # Optionally, if you set this to "random", it'll load a random theme each
# # time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

# # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# plugins=(
#     brew
#     cabal
#     colored-man-pages
#     command-not-found
#     common-aliases
#     git
#     go
#     lein
#     osx
#     stack
#     web-search
# )

source ~/.zplug/zplug

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/cabal", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "themes/robbyrussel", from:oh-my-zsh


# check コマンドで未インストール項目があるかどうか verbose にチェックし
# false のとき（つまり未インストール項目がある）y/N プロンプトで
# インストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose

typeset -U path PATH

# User configuration
path=(
    $HOME/.rakudobrew/bin
    $HOME/.rakudobrew/moar-nom/install/share/perl6/site/bin
    $HOME/.cabal/bin
    $HOME/.local/bin
    $HOME/.roswell/bin
    $(brew --prefix)/{bin,sbin}
    $path
)

if [ -x "`which go`" ]; then
  export GOPATH=$HOME/go
  path=(
      $GOROOT/bin(N-/)
      $GOPATH/bin(N-/)
      /usr/local/opt/go/libexec/bin(N-/)
      $path
  )
fi

$HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

eval "$(stack --bash-completion-script stack)"
eval "$(~/.rakudobrew/bin/rakudobrew init -)"

alias emacs='emacs -nw'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
source $ZSH/oh-my-zsh.sh

export LESS='-F -g -i -M -R -S -w -X -z-4'

