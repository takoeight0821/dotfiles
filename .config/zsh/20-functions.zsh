# Custom functions

# FZF-based repository navigation using ghq
function fzf-src() {
    if command -v ghq &> /dev/null && command -v fzf &> /dev/null; then
        local src=$(cat <(ghq list --full-path) <(worktree-list) | fzf --query "$LBUFFER")
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

# Create a git worktree in ~/.worktree directory
function worktree() {
    if ! command -v git &> /dev/null; then
        echo "Error: git is not installed"
        return 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Get branch name from argument
    local branch_name="$1"
    if [[ -z "$branch_name" ]]; then
        echo "Usage: worktree <branch-name>"
        return 1
    fi

    # Get repository name from remote or directory name
    local repo_name
    repo_name=$(git remote get-url origin 2>/dev/null | sed -E 's|^https://||; s|^git@||; s|:|/|; s|\.git$||' 2>/dev/null)
    if [[ -z "$repo_name" ]]; then
        repo_name=$(basename "$(git rev-parse --show-toplevel)")
    fi

    # Create worktree directory structure
    local worktree_base="$HOME/.worktree"
    local worktree_path="$worktree_base/$repo_name/$branch_name"

    # Create base directory if it doesn't exist
    if [[ ! -d "$worktree_base" ]]; then
        mkdir -p "$worktree_base"
    fi

    # Create the worktree
    if git worktree add "$worktree_path" "$branch_name" 2>/dev/null; then
        echo "Created worktree: $worktree_path"
        cd "$worktree_path"
    else
        echo "Error: Failed to create worktree for branch '$branch_name'"
        return 1
    fi
}

# List all repositories in ~/.worktree directory
function worktree-list() {
    local worktree_base="$HOME/.worktree"

    # Check if worktree directory exists
    if [[ ! -d "$worktree_base" ]]; then
        return 1
    fi

    # Find all worktree directories and output their paths
    find "$worktree_base" -type d -exec test -e '{}/.git' ';' -print -prune
}