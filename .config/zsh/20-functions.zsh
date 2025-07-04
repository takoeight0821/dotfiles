# Custom functions

# FZF-based repository navigation using ghq
function fzf-src() {
    if command -v ghq &> /dev/null && command -v fzf &> /dev/null; then
        local src=$(ghq list --full-path | fzf --query "$LBUFFER")
        if [ -n "$src" ]; then
            BUFFER="cd '$src'"
            zle accept-line
        fi
        zle -R -c
    fi
}

# FZF-based code search with ripgrep
function fzf-code() {
    if command -v rg &> /dev/null && command -v fzf &> /dev/null; then
        local file
        local line

        local query="${LBUFFER:-.}"

        read -r file line <<<"$(rg --no-heading --line-number $query | fzf -0 -1 | awk -F: '{print $1, $2}')"

        if [[ -n $file ]]; then
            # Use IDEA if USE_IDEA is set, otherwise use code or EDITOR
            if [[ $USE_IDEA == true ]] && command -v idea &> /dev/null; then
                BUFFER="idea --line $line '$file'"
            elif command -v code &> /dev/null; then
                BUFFER="code --goto '$file:$line'"
            else
                BUFFER="${EDITOR:-vim} +'$line' '$file'"
            fi
            zle accept-line
        fi
        zle -R -c
    fi
}

# Get a web page and copy it as markdown
function copymd() {
    if command -v curl &> /dev/null && command -v pandoc &> /dev/null && command -v pbcopy &> /dev/null; then
        curl -s $1 | pandoc -f html -t markdown | pbcopy
    else
        echo "Error: Missing required tools (curl, pandoc, or pbcopy)"
        return 1
    fi
}