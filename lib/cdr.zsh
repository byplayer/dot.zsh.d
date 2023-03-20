autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default true
add-zsh-hook chpwd chpwd_recent_dirs

# clean up not exist dir from cdr
my-compact-chpwd-recent-dirs () {
    emulate -L zsh
    setopt extendedglob
    local -aU reply
    integer history_size
    autoload -Uz chpwd_recent_filehandler
    chpwd_recent_filehandler
    history_size=$#reply
    reply=(${^reply}(N))
    (( $history_size == $#reply )) || chpwd_recent_filehandler $reply
}

# call clean up cdr when cd
add-zsh-hook chpwd my-compact-chpwd-recent-dirs