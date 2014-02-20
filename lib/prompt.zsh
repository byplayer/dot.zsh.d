autoload -Uz add-zsh-hook

# for async update right prompt
mkdir -p ${TMPPREFIX}

RPROMPT_WORK=${TMPPREFIX}/prompt.$$

function _prompt_is_in_git {
  if git rev-parse 2> /dev/null; then
    echo true
  else
    echo false
  fi
}

function _prompt_git_branch_name {
  echo $(git symbolic-ref --short HEAD)
}

function _prompt_git_staged {
  if ! git diff --staged --no-ext-diff --ignore-submodules --quiet --exit-code ; then
    echo "●"
  else
    echo ""
  fi
}

function _prompt_git_unstaged {
  if ! git diff --no-ext-diff --ignore-submodules --quiet --exit-code ; then
    echo "●"
  else
    echo ""
  fi
}

function _prompt_git_untracked {
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] ; then
    echo ""
  else
    echo "●"
  fi
}

function _prompt_git_not_pushed()
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



function _git_stat_update {
  if [ $(_prompt_is_in_git) = "true" ] ; then
    echo $(pwd) > ${RPROMPT_WORK}
    echo -n "%F{${RPROMPT_FG_COLOR}}[" >> ${RPROMPT_WORK}
    echo -n "%F{${VC_BRANCH_FG}}$(_prompt_git_branch_name)" >> ${RPROMPT_WORK}
    echo -n "%F{${VC_STAGED_FG}}$(_prompt_git_staged)" >> ${RPROMPT_WORK}
    echo -n "%F{${VC_UNSTAGED_FG}}$(_prompt_git_unstaged)" >> ${RPROMPT_WORK}
    echo -n "%F{${VC_UNTRACKED_FG}}$(_prompt_git_untracked)" >> ${RPROMPT_WORK}
    echo -n "%F{${VC_UNPUSHED_FG}}$(_prompt_git_not_pushed)" >> ${RPROMPT_WORK}
    echo "%F{${RPROMPT_FG_COLOR}}:%(4~,%-1~/.../%2~,%~)]%f" >> ${RPROMPT_WORK}

    kill -s USR2 $$
  fi
}

function _async_git_stat_update {
  RPROMPT=$RPROMPT_BASE

  if [ ! -f ${RPROMPT_WORK} ] ; then
    _git_stat_update &!
  fi
}

function TRAPUSR2 {
  if [ -f ${RPROMPT_WORK} ] ; then
    lines=( ${(@f)"$(< ${RPROMPT_WORK})"} )
    if [[ "$lines[1]" = "$(pwd)" ]] ; then
      RPROMPT=$lines[2]
    fi
    rm -f ${RPROMPT_WORK}

    # Force zsh to redisplay the prompt.
    zle && zle reset-prompt
  fi
}

add-zsh-hook precmd _async_git_stat_update


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

RPROMPT_BASE="%F{${RPROMPT_FG_COLOR}}[%(4~,%-1~/.../%2~,%~)%f]"
RPROMPT=${RPROMPT_BASE}

