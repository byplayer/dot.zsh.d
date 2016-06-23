# git env
export PATH=/opt/git/bin:/opt/git/contrib/diff-highlight:~/.git-extensions/bin:$PATH
export MANPATH=/opt/git/share/man:`manpath -q`
alias g="git"

fpath=($ZSH_EXT_BASE/plugins/git $fpath)

