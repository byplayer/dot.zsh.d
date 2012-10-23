autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ':%b'
zstyle ':vcs_info:*' actionformats ':%b|%a'

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "●"
  zstyle ':vcs_info:git:*' unstagedstr "▲"
  zstyle ':vcs_info:git:*' formats ':%b%c%u'
  zstyle ':vcs_info:git:*' actionformats ':%b|%a:%c%u'
fi

function _has_string()
{
  if [ `echo "$1" | grep "$2"` ] ; then
    echo 'OK'
  fi
}

function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info

  # psvar[1] = repository name
  # psvar[2] = staged status
  # psvar[3] = unstaged stagus
  # psvar[4] = untracked status
  # psvar[5] = unpushed status

  if [[ -n "$vcs_info_msg_0_" ]]; then
    psvar[1]=$(echo "$vcs_info_msg_0_" | sed -e 's/●//g' | sed -e 's/▲//g')
    if [ "$(_has_string $vcs_info_msg_0_, '●')" = "OK" ]; then
       psvar[2]="●"
    fi

    if [ "$(_has_string $vcs_info_msg_0_, '▲')" = "OK" ]; then
       psvar[3]="●"
    fi
    psvar[4]=$(_git_untracked)
    psvar[5]=$(_git_not_pushed)
  fi
}

function _git_not_pushed()
{

    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ] \
       && [ "$(g remote | wc | awk '{print $1;}' 2>/dev/null)" -ne "0" ] ; then
    head="$(git rev-parse HEAD 2>/dev/null)"
    for x in $(git rev-parse --remotes)
    do
      if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo "▲"
  fi
  return 0
}

function _git_untracked()
{
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
  } else {
    echo "●"
  }

  return 0
}

add-zsh-hook precmd _update_vcs_info_msg


# prompt
PROMPT_FG_COLOR=white
RPROMPT_FG_COLOR=white

# git status
# untracked yellow ●
# modify    red ●
# staged   green ●
# unpush   red ▲
VC_BRANCH_FG=blue
VC_STAGED_FG=green
VC_UNSTAGED_FG=red
VC_UNTRACKED_FG=yellow
VC_UNPUSHED_FG=red

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


RPROMPT="%F{${RPROMPT_FG_COLOR}}[%(4~,%-1~/.../%2~,%~)%f%1(v|%F{${VC_BRANCH_FG}}%1v%F{${VC_STAGED_FG}}%2v%F{${VC_UNSTAGED_FG}}%3v%F{${VC_UNTRACKED_FG}}%4v%F{${VC_UNPUSHED_FG}}%5v%f|)%F{${RPROMPT_FG_COLOR}}]%f"
