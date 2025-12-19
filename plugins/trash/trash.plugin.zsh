case ${OSTYPE} in
darwin*)
    export PATH=${HOMEBREW_PREFIX}/opt/trash/bin:$PATH
    alias rm="trash"
    ;;
esac
