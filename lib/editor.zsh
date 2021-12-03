# emacs config
# alias emacs='XMODIERS="@im=none" LC_CTYPE="ja_JP.utf8" emacs 2>/dev/null'


alias ec="emacsclient"

function ecn {
    local args

    if [[ $# -eq 2 ]]; then
        args="+$2 $1"
    else
        args=`echo $1 | sed -E "s/([^:]+):([0-9:]+)/+\2 \1/g"`
    fi

    eval "emacsclient -n $args"
}

case ${OSTYPE} in
  darwin*)
    export EDITOR"=code --wait"
    alias emacs='open -a /Applications/Emacs.app'
    ;;
  *)
    alias emacs='XMODFIERS="@im=none" emacs 2>/dev/null'
    export EDITOR=emacsclient
    ;;
esac

export ALTERNATE_EDITOR="code"
