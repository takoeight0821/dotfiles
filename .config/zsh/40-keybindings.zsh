# Vi mode configuration
bindkey -v

# Vi mode key bindings
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^G'  send-break
bindkey -M viins '^K'  kill-line

# Register custom functions as ZLE widgets
if typeset -f fzf-src > /dev/null; then
    zle -N fzf-src
    bindkey -M viins '^]' fzf-src
fi

if typeset -f fzf-code > /dev/null; then
    zle -N fzf-code
    bindkey -M viins '^f' fzf-code
fi