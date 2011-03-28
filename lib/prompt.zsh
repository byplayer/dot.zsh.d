autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ':%b'
zstyle ':vcs_info:*' actionformats ':%b|%a'

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats ':%b:%c%u'
  zstyle ':vcs_info:git:*' actionformats ':%b|%a:%c%u'
fi

function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[2]=$(_git_not_pushed)
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

function _git_not_pushed()
{
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes)
    do
      if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo "?"
  fi
  return 0
}

add-zsh-hook precmd _update_vcs_info_msg


# prompt
PROMPT_FG_COLOR=white
RPROMPT_FG_COLOR=white
VC_FG_COLOR=blue

case ${UID} in
0)
  PROMPT_FG_COLOR=red
  ;;
*)
  PROMPT_FG_COLOR=white
  ;;
esac

PROMPT_CL_PREFIX="%F{${PROMPT_FG_COLOR}}"
PROMPT_PREFIX="${PROMPT_CL_PREFIX}"

PROMPT_CL_SUFIX="%f"
RPROMPT_CL_SUFIX="%f"

[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT_PREFIX="${PROMPT_PREFIX}%n@%m"

PROMPT="${PROMPT_PREFIX}%#${PROMPT_CL_SUFIX} "
PROMPT2="${PROMPT_CL_PREFIX}%_\$${PROMPT_CL_SUFIX} "
SPROMPT="${PROMPT_CL_PREFIX}%r is correct? [n,y,a,e]:${PROMPT_CL_SUFIX} "


RPROMPT="%F{${RPROMPT_FG_COLOR}}[%(4~,%-1~/.../%2~,%~)%f%1(v|%F{${VC_FG_COLOR}}%1v%2v%f|)%F{${RPROMPT_FG_COLOR}}]%f"
