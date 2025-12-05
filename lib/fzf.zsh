export PATH=/opt/fzf/bin:$PATH
export MANPATH=/opt/fzf/man:`manpath -q`

export FZF_TMUX_HEIGHT=60

# to support ** completion and kill completion
#
#   kill <TAB>
#   cd ../**<TAB>
#   emacs **<TAB>
if [ -f /opt/fzf/shell/completion.zsh ]; then
  source /opt/fzf/shell/completion.zsh
fi

case ${OSTYPE} in
  darwin*)
    source $(brew ls fzf | grep --color=no shell | grep --color=no completion.zsh)
  ;;
esac

export FZF_DEFAULT_OPTS='--border --ansi --reverse --exit-0'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:000000,bg:#ffffff,hl:#177899 --color=fg+:#ffffff,bg+:#008cd7,hl+:#adebff --color=info:#afaf87,prompt:#cc0058,pointer:#d5abff --color=marker:#77e304,spinner:#a64cff,header:#87afaf'

__fzf_is_binary() {
  a=$(file --mime "$1" | grep "charset=binary")
  if [ -n "$a" ]; then return 0; fi
  return 1
}

__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

# CTRL-G C for cdr
function fzf-cdr () {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | $(__fzfcmd) --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-cdr
bindkey "^gc" fzf-cdr

# overwite to add accept-line and preview option
__fzf_generic_path_completion() {
  local base lbuf compgen fzf_opts suffix tail fzf dir leftover matches
  base=$1
  lbuf=$2
  compgen=$3
  fzf_opts=$4
  suffix=$5
  tail=$6
  fzf="$(__fzfcmd_complete)"

  setopt localoptions nonomatch
  eval "base=$base"
  [[ $base = *"/"* ]] && dir="$base"
  while [ 1 ]; do
    if [[ -z "$dir" || -d ${dir} ]]; then
      leftover=${base/#"$dir"}
      leftover=${leftover/#\/}
      [ -z "$dir" ] && dir='.'
      [ "$dir" != "/" ] && dir="${dir/%\//}"
      matches=$(eval "$compgen $(printf %q "$dir")" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" ${=fzf} ${=fzf_opts} --preview 'if [ -d {} ] ; then ; echo {} is directory ; tree -C {} | head -200; elif [ $(file --mime {} 2> /dev/null > /dev/null) ] ; then echo {} is binary ; else highlight -l -s olive -O truecolor --force {} | head -500 ; fi' -q "$leftover" | while read item; do
        echo -n "${(q)item}$suffix "
      done)
      matches=${matches% }
      if [ -n "$matches" ]; then
        LBUFFER="$lbuf$matches$tail"
        zle accept-line
      fi
      zle reset-prompt
      break
    fi
    dir=$(dirname "$dir")
    dir=${dir%/}/
  done
}

# git log command
fzf-git-log ()
{
  git lg | \
   fzf --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
    FZF-EOF" --preview-window=down:60%
}

fzf-git-log-all ()
{
  git lga | \
   fzf --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
    FZF-EOF" --preview-window=down:60%
}

alias glg=fzf-git-log
alias glga=fzf-git-log

# ag + fzf
function fzf-ag () {
  if [ -z "$1" ]; then
    echo 'Usage: fzf-ag PATTERN'
    return 0
  fi
  result=`ag $1 | fzf --preview-window=down:50% --preview 'highlight -l -s github -O truecolor --force $(echo {} | awk -F: -f ~/.zsh.d/lib/fzf-ag-file.awk) | tail -n +$(echo {} | awk -F: -f ~/.zsh.d/lib/fzf-ag-file-line.awk)'`
  line=`echo "$result" | awk -F ':' '{print $2}'`
  file=`echo "$result" | awk -F ':' '{print $1}'`
  if [ -n "$file" ]; then
    echo code -g ${file}:${line}
    code -g ${file}:${line}
  fi
}
alias fag=fzf-ag
