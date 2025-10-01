case ${OSTYPE} in
darwin*)
    export PATH=$(brew --prefix trash)/bin:$PATH
    alias rm="trash"
    ;;
esac
