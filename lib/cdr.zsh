autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default true
add-zsh-hook chpwd chpwd_recent_dirs
