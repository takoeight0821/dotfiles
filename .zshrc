# source ~/.zplug/zplug
autoload -U +X compinit && compinit

export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "plugins/brew", from:oh-my-zsh
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

ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

typeset -U path PATH

# User configuration
path=(
    $HOME/bin(N-/)
    $HOME/.cabal/bin(N-/)
    $HOME/.egison/bin(N-/)
    $HOME/Lisp/bin(N-/)
    $HOME/.local/bin(N-/)
    $HOME/.roswell/bin(N-/)
    $HOME/.ghq/github.com/cxxxr/lem(N-/)
    $HOME/.cargo/bin(N-/)
    /usr/local/bin(N-/)
    $path
)

if [ -x "`which go`" ]; then
    export GOPATH=$HOME/.go
    path=( $GOPATH/bin $path )
fi

[ -x "`which brew`" ] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
fi

autoload -U +X bashcompinit && bashcompinit
[ -x "`which stack`" ] && eval "$(stack --bash-completion-script stack)"

[ -x "`which opam`" ] && eval `opam config env` && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

alias opam-upgrade!='wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin/'

complete -cf sudo

alias emacs='emacs -nw'
alias emacsclient='emacsclient -nw -a ""'
[ -e '/Applications/MacVim.app' ] && alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

export LESS='-F -g -i -M -R -S -w -X -z-4'

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

BASE16_SHELL="$HOME/.config/base16-shell/base16-railscasts.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

RUST_SRC_PATH="$(ghq root)/github.com/rust-lang/rust/src"
export RUST_SRC_PATH

function docker-setup() {
  eval "$(docker-machine env $1)"
}

alias mikutter="ruby $(ghq root)/github.com/mikutter/mikutter/mikutter.rb &"

alias spacemacs="HOME=~/spacemacs /usr/bin/env emacs"
