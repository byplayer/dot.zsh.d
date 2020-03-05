export PATH=/opt/unco/bin:$PATH
export MANPATH=/opt/unco/share/man:`manpath -q`
fpath=($ZSH_EXT_BASE/plugins/unco $fpath)

# add hook to use unco record --
# If I use alias git="unco record -- git"
# I cannot use zsh completion.
# so I add unco hook
# UNCO_HOOK_CMDS=(git rm)
# unco-hook-accept-line () {
#   if [[ "$BUFFER" == "g "* ]]; then
#     BUFFER="unco record -- git ${BUFFER##g }"
#   else
#     for c in $UNCO_HOOK_CMDS; do
#       if [[ "$BUFFER" == "$c "* ]]; then
#         BUFFER="unco record -- ${BUFFER}"
#       fi
#     done
#   fi

#   zle .accept-line
# }

# zle -N accept-line unco-hook-accept-line
