# ベルを鳴らさない。
setopt no_beep

# バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# cdでpushdする。
setopt auto_pushd

# ディレクトリ名でcd
setopt auto_cd

# 間違えたら訂正を出す
setopt correct

# キーをemacs風に
bindkey -e

# freemind
export PATH=/opt/freemind:$PATH

# mysql
export PATH=/usr/local/mysql/bin:$PATH
export MANPATH=/usr/local/mysql/man:`manpath -q`
export LD_LIBRARY_PATH=/usr/local/mysql/lib/mysql:$LD_LIBRARY_PATH

# tmux
export PATH=/opt/tmux/bin:$PATH
export MANPATH=/opt/tmux/share/man:`manpath -q`

# less color option
export LESS='-R'

# alias 設定
case ${OSTYPE} in
  darwin*)
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
    export PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH
    export PATH=/opt/local/share/git/contrib/diff-highlight:$PATH
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/opt/qt/bin:$PATH
    ;;
esac
alias ls="ls -CF --color"

alias cd_gtop='cd `git top`'

# tmux
alias tmux="tmux -2"

# zsh-completions
fpath=(~/.zsh.d/plugins/zsh-completions/src $fpath)

# add path private scripts
export PATH=~/.bin:$PATH

function ymd_date() {
  date +%Y%m%d
}

# use custom emacs
export PATH=/opt/emacs/bin:${PATH}
