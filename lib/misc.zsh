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
export PATH=/usr/local/freemind:$PATH

# ctags 環境設定
export PATH=/usr/local/ctags/bin:$PATH
export MANPATH=/usr/local/ctags/share/man:`manpath -q`

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
    alias ls="gls -CF --color"
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/man:$MANPATH
  ;;
  *)
    alias ls="ls -CF --color"
    ;;
esac

alias cd_gtop="cd `git top`"

# tmux
alias tmux="tmux -2"

# zsh-completions
fpath=(~/.zsh.d/plugins/zsh-completions/src $fpath)

# add path private scripts
export PATH=~/.bin:$PATH
