export PATH=/opt/fzf/bin:$PATH
export MANPATH=/opt/fzf/man:`manpath -q`

export FZF_DEFAULT_OPTS='--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:150,header:#61afef
--reverse --select-1 --exit-0 --multi'

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
