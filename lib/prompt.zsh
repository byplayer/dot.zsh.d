autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ':%b'
zstyle ':vcs_info:*' actionformats ':%b|%a'
vcs_console () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

precmd () {
  vcs_console;
}

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


RPROMPT="%F{${RPROMPT_FG_COLOR}}[%(4~,%-1~/.../%2~,%~)%f%1(v|%F{${VC_FG_COLOR}}%1v%f|)%F{${RPROMPT_FG_COLOR}}]%f"
