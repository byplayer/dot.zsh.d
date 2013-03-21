# git env
export PATH=/usr/local/git/bin:~/.git-extensions/bin:$PATH
export MANPATH=/usr/local/git/share/man:`manpath -q`
alias g="git"

source ${ZSH_EXT_BASE}/plugins/git/git-completion.bash