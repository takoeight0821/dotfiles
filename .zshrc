
# Check if zplug is installed
# if [[ ! -d ~/.zplug ]]; then
#   git clone https://github.com/zplug/zplug ~/.zplug
#   source ~/.zplug/init.zsh && zplug update --self
# fi

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "psprint/zsh-navigation-tools"
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh
zplug "themes/robbyrussell", from:oh-my-zsh

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

eval $(cat $ZPLUG_HOME/repos/robbyrussell/oh-my-zsh/themes/robbyrussell.zsh-theme)

export EDITOR='emacs'

typeset -U path PATH fpath

# User configuration
path=(
    /usr/local/opt/llvm/bin(N-/)
    /usr/local/opt/llvm/share/llvm(N-/)
    $HOME/bin(N-/)
    $HOME/.cabal/bin(N-/)
    $HOME/.egison/bin(N-/)
    $HOME/Lisp/bin(N-/)
    $HOME/.local/bin(N-/)
    $HOME/.roswell/bin(N-/)
    $HOME/.cargo/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

fpath=($HOME/.zsh /usr/local/share/zsh/site-functions $ZPLUG_HOME/repos/zsh-users/zsh-completions $fpath)

autoload -U +X compinit && compinit -u
autoload -U +X bashcompinit && bashcompinit -u

complete -cf sudo

HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z} r:|[-_.]=**'

export JAVA_HOME=$(/usr/libexec/java_home)

if [ -x "`which go`" ]; then
    export GOPATH=$HOME/Projects/Repos/Go
    path=( $GOPATH/bin $path )
fi

[ -x "`which ros`" ] && alias ros='rlwrap ros'

[ -x "`which brew`" ] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"

[ -x "`which stack`" ] && eval "$(stack --bash-completion-script stack)"

[ -x "`which opam`" ] && eval `opam config env` && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

alias opam-upgrade!='wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin/'

[ -e '/Applications/MacVim.app' ] && alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

export LESS='-F -g -i -M -R -S -w -X -z-4'
alias ls='ls -G'
alias la='ls -G -a'

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-railscasts.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src
export RUST_SRC_PATH

function docker-setup() {
  eval "$(docker-machine env $1)"
}

## create emacs env file
perl -wle \
    'do { print qq/(setenv "$_" "$ENV{$_}")/ if exists $ENV{$_} } for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el

alias emacs='emacs -nw'

[ -x "`which sagittarius`" ] && alias sagittarius='rlwrap sagittarius'

export PGDATA=/usr/local/var/postgres

. ~/erlang/19.2/activate

export HAXE_STD_PATH="/usr/local/lib/haxe/std"

# added by travis gem
[ -f /Users/konoyuya/.travis/travis.sh ] && source /Users/konoyuya/.travis/travis.sh

