case ${OSTYPE} in
darwin*)
    export PATH=$(brew --prefix llvm)/bin:$PATH
    ;;
esac
