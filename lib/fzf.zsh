export PATH=/opt/fzf/bin:$PATH
export MANPATH=/opt/fzf/man:`manpath -q`

export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --select-1 --exit-0 --multi'

function fzf-cdr () {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-cdr
bindkey "^gc" fzf-cdr
