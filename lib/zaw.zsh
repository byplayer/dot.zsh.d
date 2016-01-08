bindkey '^gz' zaw
bindkey '^gb' zaw-git-recent-all-branches
bindkey '^gs' zaw-git-status
bindkey '^r' zaw-history
bindkey '^gc' zaw-cdr

export ZAW_EDITOR='emacsclient -n'

zstyle ':filter-select:highlight' matched fg=yellow,standout
zstyle ':filter-select:highlight' selected fg=black,fg=white,standout