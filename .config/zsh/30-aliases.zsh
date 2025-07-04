# Git aliases
alias wip='git commit --fixup $(git log -1 --pretty=format:"%H" --grep="^fixup\!" --invert-grep)'

# Common aliases (add more as needed)
# alias ll='ls -la'
# alias la='ls -A'
# alias l='ls -CF'