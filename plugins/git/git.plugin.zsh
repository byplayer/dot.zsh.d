# git env
export PATH=/opt/git/bin:/opt/git/contrib/diff-highlight:~/.git-extensions/bin:$PATH
export MANPATH=/opt/git/share/man:`manpath -q`

# abbreviations for git
abbr -S --quiet "git br"="git branch"
abbr -S --quiet "git chp"="git cherry-pick"
abbr -S --quiet "git ci"="git commit"
abbr -S --quiet "git cia"="git commit --amend"
abbr -S --quiet "git co"="git checkout"
abbr -S --quiet "git d"="git diff"
abbr -S --quiet "git dc"="git diff --check"
abbr -S --quiet "git dname"="git diff --name-only"
abbr -S --quiet "git dns"="git diff --name-status"
abbr -S --quiet "git ds"="git diff --stat"
abbr -S --quiet "git dt"="git difftool"
abbr -S --quiet "git dmb"='git diff $(git merge-base develop HEAD)'
abbr -S --quiet "git dw"="git diff --color-words"
abbr -S --quiet "git l"="git log --color"
abbr -S --quiet "git lg"="git log --graph --pretty=format:'%C(yellow)%h%C(green)%d%Creset %s %Cblue[%ad]%C(bold blue)<%an>%Creset' --abbrev-commit --date=short --branches --color"
abbr -S --quiet "git lga"="git log --graph --pretty=format:'%C(yellow)%h%C(green)%d%Creset %s %Cblue[%ad]%C(bold blue)<%an>%Creset' --abbrev-commit --date=short --branches --all --color"
abbr -S --quiet "git lo"="git log --oneline --color"
abbr -S --quiet "git mg"="git merge"
abbr -S --quiet "git mt"="git mergetool"
abbr -S --quiet "git r.p.o"="git remote prune origin"
abbr -S --quiet "git r.p"="git remote prune"
abbr -S --quiet "git r.s.o"="git remote show origin"
abbr -S --quiet "git r.s"="git remote show"
abbr -S --quiet "git sm"="git submodule"
abbr -S --quiet "git st"="git status"
abbr -S --quiet "git sw"="git switch"
abbr -S --quiet "git swc"="git switch -c"
abbr -S --quiet "git tags"="git tag -s"
abbr -S --quiet "git top"="git rev-parse --show-toplevel"
abbr -S --quiet "git wt.l"="git worktree list"
abbr -S --quiet "git wt.p"="git worktree prune -v"
abbr -S --quiet "git wt.r"="git worktree remove"
abbr -S --quiet "git wt"="git worktree"
abbr -S --quiet g="git"

case ${OSTYPE} in
  darwin*)
    export PATH=$(brew --prefix git)/share/git-core/contrib/diff-highlight:$PATH
    ;;
esac

export PATH=$PATH:$ZSH_EXT_BASE/plugins/git/bin
fpath=($ZSH_EXT_BASE/plugins/git $fpath)
