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

# use 256 color in terminal
export TERM=xterm-256color
# zsh-completions
fpath=(~/.zsh.d/plugins/zsh-completions/src $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# alias 設定
case ${OSTYPE} in
  darwin*)
    export PATH=$(brew --prefix coreutils)/libexec/gnubin/:$PATH
    export MANPATH=$(brew --prefix coreutils)/libexec/gnuman:$MANPATH
    export PATH=$(brew --prefix findutils)/libexec/gnubin:$PATH
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
    ;;
esac
alias ls="ls -CF --color"

alias cd_gtop='cd `git top`'

# tmux
alias tmux="tmux -2"

# add path private scripts
export PATH=~/.bin:$PATH

function ymd_date() {
  date +%Y%m%d
}

# use custom emacs
export PATH=/opt/emacs/bin:${PATH}
