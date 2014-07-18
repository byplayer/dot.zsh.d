# git env
export PATH=/opt/git/bin:~/.git-extensions/bin:$PATH
export MANPATH=/opt/git/share/man:`manpath -q`
alias g="git"

fpath=($ZSH_EXT_BASE/plugins/git $fpath)

