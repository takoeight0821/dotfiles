source ~/.zsh_profile

# Check if zplug is installed
if [ ! -d ~/.zplug ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "themes/robbyrussell", from:oh-my-zsh
zplug "plugins/asdf", from:oh-my-zsh

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

# eval $(cat $ZPLUG_HOME/repos/robbyrussell/oh-my-zsh/themes/robbyrussell.zsh-theme)

HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt share_history

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z} r:|[-_.]=**'


if [ -x "`which go`" ]; then
    path=( $(go env GOPATH)/bin $path )
fi

[ -x "`which ros`" ] && alias ros='rlwrap ros'

[ -x "`which brew`" ] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"


# [ -x "`which opam`" ] && eval `opam config env` && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[ -x "`which opam`" ] && eval "$(opam env)"

export LESS='-F -g -i -M -R -S -w -X -z-4'
alias ls='ls -G'
alias la='ls -G -a'


[ -x "`which gcc-7`" ] && alias gcc=gcc-7 && alias gcc89="gcc-7 -std=c89"
[ -x "`which g++-7`" ] && alias g++=g++-7

# test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# # Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#         eval "$("$BASE16_SHELL/profile_helper.sh")"

function docker-setup() {
  eval "$(docker-machine env $1)"
}

[ -x "`which sagittarius`" ] && alias sagittarius='rlwrap sagittarius'

export PGDATA=/usr/local/var/postgres

# . ~/.kerl/19.3/activate

# export HAXE_STD_PATH="/usr/local/lib/haxe/std"

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

[ -x "`which rbenv`" ] && eval "$(rbenv init -)"

function peco-src() {
    local src=$(ghq list --full-path | fzf --query "$LBUFFER")
    if [ -n "$src" ]; then
        BUFFER="cd '$src'"
        zle accept-line
    fi
    zle -R -c
}
zle -N peco-src

bindkey -v
bindkey -M vicmd '^[' undefined-key
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank

bindkey -M viins '^]' peco-src

autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
    print -rn -- $terminfo[el]
}
add-zsh-hook preexec left_down_prompt_preexec

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

function zle-keymap-select zle-line-init zle-line-finish
{
    setopt prompt_subst
    case $KEYMAP in
        main|viins)
            PROMPT_2="$fg[cyan]-- INSERT --$reset_color"
            ;;
        vicmd)
            PROMPT_2="$fg[white]-- NORMAL --$reset_color"
            ;;
        vivis|vivli)
            PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
            ;;
    esac
    RPROMPT="[$(git_prompt_info)%(?.%{${fg[green]}%}.%{${fg[red]}%})%n%{${reset_color}%} %~]"
    # RPROMPT="[%(?.%{${fg[green]}%}.%{${fg[red]}%})%n%{${reset_color}%} %~]"
    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})%1d%{${reset_color}%}]$ "
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

export ECLIPSE_HOME=~/Applications/Eclipse.app

alias ccat='pygmentize -f console'
# alias emacs='emacs -nw'
alias emacs='emacsclient -nw -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'
# alias spacemacs='HOME=~/spacemacs \emacs'
# alias pg='HOME=~/proofgeneral emacs'
## create emacs env file
perl -wle \
    'do { print qq/(setenv "$_" "$ENV{$_}")/ if exists $ENV{$_} } for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el
export CARP_DIR=$HOME/dev/src/github.com/carp-lang/Carp

export SATYSFI_LIB_ROOT="$HOME/dev/src/github.com/gfngfn/SATySFi/lib-satysfi"

export KIT_STD_PATH="$HOME/dev/src/github.com/kitlang/kit/std"

# [ -x "`which stack`" ] && eval "$(stack --bash-completion-script `which stack`)"

[ -x "`which rustc`" ] && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# [ -x "`which malgoc`" ] && source <(malgoc --bash-completion-script "`which malgoc`")

export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"

# added by travis gem
[ ! -s /Users/yuya/.travis/travis.sh ] || source /Users/yuya/.travis/travis.sh

# GraalVM
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.3.0/Contents/Home
# export JAVA_TOOL_OPTIONS='-Duser.language=en'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/yuya/.sdkman"
[[ -s "/Users/yuya/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/yuya/.sdkman/bin/sdkman-init.sh"

alias vim='nvim'

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

PATH="/Users/yuya/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/yuya/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/yuya/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/yuya/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/yuya/perl5"; export PERL_MM_OPT;


alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(direnv hook zsh)"

if [ -x "`which aqua`" ]; then
    path=( $path $(aqua root-dir)/bin )
fi


# pnpm
export PNPM_HOME="/Users/yuya/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
