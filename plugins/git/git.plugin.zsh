# git env
export PATH=/opt/git/bin:/opt/git/contrib/diff-highlight:~/.git-extensions/bin:$PATH
export MANPATH=/opt/git/share/man:`manpath -q`
alias g="git"

case ${OSTYPE} in
  darwin*)
    export PATH=${HOMEBREW_PREFIX}/opt/git/share/git-core/contrib/diff-highlight:$PATH
    ;;
esac

export PATH=$PATH:$ZSH_EXT_BASE/plugins/git/bin
fpath=($ZSH_EXT_BASE/plugins/git $fpath)
