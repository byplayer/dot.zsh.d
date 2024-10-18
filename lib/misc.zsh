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
export MANPATH=/usr/local/mysql/man:$(manpath -q)
export LD_LIBRARY_PATH=/usr/local/mysql/lib/mysql:$LD_LIBRARY_PATH

# tmux
export PATH=/opt/tmux/bin:$PATH
export MANPATH=/opt/tmux/share/man:$(manpath -q)

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
  export PATH=$(brew --prefix make)/libexec/gnubin:$PATH
  export PATH=$(brew --prefix gcc)/bin:$PATH
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
  ;;
esac

EZA_COLORS="uu=38;5;124:ux=38;5;30:ue=38;5;30:ur=38;5;124:uw=38;5;160"
EZA_COLORS+=":gu=38;5;172"
EZA_COLORS+=":nk=38;5;31"
EZA_COLORS+=":ex=38;5;30"
EZA_COLORS+=":sc=38;5;166"
EZA_COLORS+=":bu=38;5;3"
EZA_COLORS+=":cr=38;5;28"
EZA_COLORS+=":*.rb=38;5;124:*.md=38;5;52"
EZA_COLORS+=":*.rs=38;5;88"
EZA_COLORS+=":*.bk=38;5;245"
EZA_COLORS+=":*.tmp=38;5;245"
EZA_COLORS+=":*~=38;5;245"
export EZA_COLORS

alias ls="eza -g --icons --git"

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
