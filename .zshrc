source ~/.zplug/zplug

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

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

source $ZPLUG_HOME/repos/robbyrussell/oh-my-zsh/themes/robbyrussell.zsh-theme

typeset -U path PATH

# User configuration
path=(
    $HOME/.local/bin(N-/)
    $HOME/.roswell/bin(N-/)
    $(brew --prefix)/{bin,sbin}(N-/)
    $path
)

if [ -x "`which go`" ]; then
    export GOPATH=$HOME/.go
    path=( $GOPATH/bin $path )
fi

[ -x "`which brew`" ] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
[ -x "`which stack`" ] && eval "$(stack --bash-completion-script stack)"

. $HOME/.nix-profile/etc/profile.d/nix.sh

[ -x "`which opam`" ] && eval `opam config env` && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

alias opam-upgrade!='wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin/'

alias emacs='emacs -nw'
[ -e '/Applications/MacVim.app' ] && alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
export LESS='-F -g -i -M -R -S -w -X -z-4'
